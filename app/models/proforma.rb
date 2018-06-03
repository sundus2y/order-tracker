class Proforma < ActiveRecord::Base

  has_many :proforma_items, dependent: :destroy
  belongs_to :customer
  belongs_to :car
  belongs_to :store
  belongs_to :creator, class_name: 'User'
  has_one :sale

  before_create :set_transaction_num
  after_save :update_grand_total

  validates_presence_of :customer_id, :store_id

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :submitted, lambda { where(status: 'submitted') }
  scope :sold, lambda { where(status: 'sold') }
  scope :void, lambda { where(status: 'void') }
  scope :current_year, lambda {where("created_at > '#{Time.zone.now.beginning_of_year}'")}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :submitted
    state :sold
    state :void

    event :submit, after: :submit_proforma_items do
      transitions :from => :draft, :to => :submitted, unless: :empty_proforma_item? #SALE
    end

    event :mark_as_sold, after: [:create_sales_from_proforma, :mark_as_sold_items] do
      transitions :from => :submitted, :to => :sold, after: :set_sold_at, unless: :empty_proforma_item? #SALE
    end

    event :reject, after: :reject_proforma_items do
      transitions :from => [:sold,:submitted], :to => :void #ADMIN
    end

    event :delete_draft, after: :delete_proforma_items do
      transitions :from => :draft, :to => :void
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
    def submit_proforma_items
      proforma_items.map(&:submit!)
    end

    def mark_as_sold_items
      proforma_items.map(&:mark_as_sold!)
    end

    def reject_proforma_items
      proforma_items.map(&:reject!)
    end

    def delete_proforma_items
      proforma_items.map(&:delete!)
    end

    def empty_proforma_item?
      proforma_items_count == 0
    end

    def create_sales_from_proforma(params)
      sale_items_attributes = proforma_items.map do |proforma_item|
        {
            item_id: proforma_item.item_id,
            qty: proforma_item.qty,
            unit_price: proforma_item.unit_price,
            created_at: DateTime.now,
            updated_at: DateTime.now
        }
      end
      Sale.create!(
          {
              customer_id: customer_id,
              car_id: car_id,
              store_id: store_id,
              remark: "Created From Proforma #: #{transaction_num}",
              created_at: DateTime.now,
              updated_at: DateTime.now,
              creator_id: params[:current_user_id],
              proforma_id: id,
              sale_items_attributes: sale_items_attributes
          }
      )
    end

    def set_transaction_num
      counter = TransactionNumCounter.get_transaction_next_num_for(store.id, 'Proforma')
      self.transaction_num = "S-PRO-#{store.id}-#{created_at.strftime('%Y%m%d')}-#{counter}"
    end

    def update_grand_total
      gt = proforma_items.inject(0) do |n,proforma_item|
        n + (proforma_item.qty*proforma_item.unit_price)
      end
      update_column('grand_total',gt*1.15)
    end

    def set_sold_at
      update_column('sold_at',Time.zone.now)
    end
end
