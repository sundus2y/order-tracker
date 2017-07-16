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
  scope :current_year, lambda {where("updated_at > '#{Time.zone.now.beginning_of_year}'")}

  # default_scope { includes(:sale_items).reorder(updated_at: :desc)}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :credited
    state :sampled
    state :returned
    state :void

    event :submit, after: :submit_sale_items do
      transitions :from => :draft, :to => :sold, unless: :empty_sale_item? #SALE
    end

    event :mark_as_sold, after: :mark_as_sold_items do
      transitions :from => [:sampled,:credited], :to => :sold, unless: :empty_sale_item? #SALE
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
    end
    search_query
  end

  def self.top_10
    Sale.sold.order('grand_total desc').limit(10)
  end

  def self.monthly_sales
    Sale.sold.current_year.group("date_trunc('month', updated_at)").order('date_trunc_month_updated_at').sum(:grand_total).to_a
    # Sale.sold.group("date_part('week', updated_at)").order('date_part_week_updated_at').sum(:grand_total).to_a
  end

  def self.this_week_sales
    Sale.sold.where(updated_at: [Time.zone.now.beginning_of_week..Time.zone.now.end_of_week]).sum(:grand_total)
  end

  def self.weekly_sales_change
    last_week = Sale.sold.where(updated_at: [1.week.ago.beginning_of_week..1.week.ago]).sum(:grand_total)
    this_week = Sale.sold.where(updated_at: [Time.zone.now.beginning_of_week..Time.zone.now]).sum(:grand_total)
    ((this_week - last_week)/last_week*100)
  end

  def self.daily_sales
    Sale.sold.where(updated_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day]).sum(:grand_total)
  end

  def self.daily_customers
    Sale.sold.where(updated_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day]).distinct.count(:customer_id)
  end

  def formatted_created_at
    created_at.to_formatted_s(:long) if created_at
  end

  def formatted_updated_at
    updated_at.to_formatted_s(:long) if updated_at
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
      self.transaction_num = "S-ORD-#{created_at.strftime('%Y%m%d')}-#{store.id}-#{counter}"
    end

    def update_grand_total
      gt = sale_items.inject(0) do |n,sale_item|
        n + (sale_item.qty*sale_item.unit_price)
      end
      update_column('grand_total',gt)
    end

end
