class Sale < ActiveRecord::Base
  enum store: [:t_shop, :l_shop, :l_store]

  has_many :sale_items
  belongs_to :customer

  validates_presence_of :customer_id, :store, :created_at

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sold, lambda { where(status: 'sold') }
  scope :accepted, lambda { where(status: 'accepted') }

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :accepted

    event :submit, after: :submit_sale_items do
      transitions :from => :draft, :to => :sold #SALE
      transitions :from => :sold, :to => :accepted #ADMIN
    end

    event :reject, after: :reject_sale_items do
      transitions :from => [:sold,:accepted], :to => :draft #ADMIN
    end
  end

  def sale_items_json
    as_json({
                include: {
                    sale_items: SaleItem.json_options
                },
                only: [:id]
            })
  end

  def status_upcase
    status.upcase
  end

  private
    def submit_sale_items
      sale_items.map(&:submit!)
    end

    def reject_sale_items
      sale_items.map(&:reject!)
    end


end