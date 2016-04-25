class SaleItem < ActiveRecord::Base

  belongs_to :sale, :counter_cache => true
  belongs_to :item

  before_create :set_unit_price

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :ready, lambda { where(status: 'sold') }
  scope :accepted, lambda { where(status: 'accepted') }
  scope :sold_by_store_and_item, -> (store_id,item_id) {includes(:sale,:item,{sale:[:customer]}).where(sales:{store:store_id},item_id:item_id,status:'sold')}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :accepted

    event :submit do
      transitions :from => :draft, :to => :sold, after: :update_inventory #SALE
      transitions :from => :ready, :to => :accepted #ADMIN
    end

    event :reject do
      transitions :from => [:sold,:accepted], :to => :draft #ADMIN
    end
  end

  def self.json_options
    {
        include: {
            item: {
                only: [:id,:name,:description,:original_number,:item_number]
            }
        },
        only:[:id,:qty,:unit_price]
    }
  end

  def self.sale_return_json_options
    {
        include: {
            item: {
                only: [:id,:name,:original_number]
            },
            sale: {
                include: {
                    customer: {
                        only: [:name, :phone]
                    }
                },
                only: [:id, :created_at]
            }
        },
        only: [:id,:qty,:unit_price]
    }
  end

  private
    def set_unit_price
      self.unit_price = item.sale_price
    end

    def update_inventory
      item.decrement!(self.sale.store.to_sym,qty)
    end

end
