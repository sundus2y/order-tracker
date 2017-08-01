class Sale < ActiveRecord::Base

  has_many :sale_items, dependent: :destroy
  belongs_to :customer
  belongs_to :store
  belongs_to :creator, class_name: 'User'

  before_create :set_transaction_num
  after_save :update_grand_total

  validates_presence_of :customer_id, :store_id

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sold, lambda { where(status: 'sold') }
  scope :credited, lambda { where(status: 'credited') }
  scope :sampled, lambda { where(status: 'sampled') }
  scope :returned, lambda { where(status: 'returned') }
  scope :void, lambda { where(status: 'void') }
  scope :current_year, lambda {where("sold_at > '#{Time.zone.now.beginning_of_year}'")}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :credited
    state :sampled
    state :returned
    state :void

    event :submit, after: :submit_sale_items do
      transitions :from => :draft, :to => :sold, after: :set_sold_at, unless: :empty_sale_item? #SALE
    end

    event :mark_as_sold, after: :mark_as_sold_items do
      transitions :from => [:sampled,:credited], :to => :sold, after: :set_sold_at, unless: :empty_sale_item? #SALE
    end

    event :credit, after: :credit_sale_items do
      transitions :from => :draft, :to => :credited, unless: :empty_sale_item? #SALE
    end

    event :sample, after: :sample_sale_items do
      transitions :from => :draft, :to => :sampled, unless: :empty_sale_item? #SALE
    end

    event :reject, after: :reject_sale_items do
      transitions :from => [:sold,:credited,:sampled], :to => :void #ADMIN
    end

    event :delete_draft do
      transitions :from => :draft, :to => :void
    end

    event :return_sale do
      transitions :from => [:sold,:accepted], :to => :returned, if: :empty_sold_item?
    end
  end

  def self.get_all_states
    aasm.states.map(&:name).map(&:to_s).map(&:upcase)
  end

  def self.search(params)
    search_query = all.includes(:customer,:store).reorder(created_at: :desc)
    search_query = search_query.where(customer_id: params[:customer_id]) if params[:customer_id].present?
    search_query = search_query.where(status: params[:status].downcase) if params[:status].present?
    search_query = search_query.where(store_id: params[:store_id]) if params[:store_id].present?
    if params[:date_from].present?
      search_query  = search_query.where("updated_at >= '#{params[:date_from]}'")
      search_query = search_query.where("updated_at <= '#{params[:date_to]}'") if params[:date_to].present?
      search_query = search_query.where("fs_num like '#{params[:fs_num]}%'") if params[:fs_num].present?
    end
    search_query
  end

  def formatted_created_at(format=:long)
    created_at.to_formatted_s(format) if created_at
  end

  def formatted_updated_at(format=:long)
    updated_at.to_formatted_s(format) if updated_at
  end

  def formatted_sold_at(format=:long)
    sold_at.to_formatted_s(format) if sold_at
  end

  def status_upcase
    status.upcase
  end

  private
    def submit_sale_items
      sale_items.map(&:submit!)
      end

    def mark_as_sold_items
      sale_items.where.not(status: 'returned').map(&:mark_as_sold!)
    end

    def reject_sale_items
      sale_items.map(&:reject!)
    end

    def credit_sale_items
      sale_items.map(&:credit!)
    end

    def sample_sale_items
      sale_items.map(&:sample!)
    end

    def empty_sale_item?
      sale_items_count == 0
    end

    def empty_sold_item?
      sold_count = sale_items.where(status: 'sold').sum(:qty)
      returned_count = sale_items.where(status: 'returned').sum(:qty)
      sold_count + returned_count == 0 ? true : false
    end

    def set_transaction_num
      counter = TransactionNumCounter.get_transaction_next_num_for(store.id)
      self.transaction_num = "S-ORD-#{store.id}-#{created_at.strftime('%Y%m%d')}-#{counter}"
    end

    def update_grand_total
      gt = sale_items.inject(0) do |n,sale_item|
        n + (sale_item.qty*sale_item.unit_price)
      end
      update_column('grand_total',gt)
    end

    def set_sold_at
      update_column('sold_at',Time.zone.now)
    end

end
