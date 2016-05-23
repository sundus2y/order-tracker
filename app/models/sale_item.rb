class SaleItem < ActiveRecord::Base

  belongs_to :sale, :counter_cache => true
  belongs_to :item
  has_many :return_items

  before_create :set_unit_price

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sold, lambda { where(status: 'sold') }
  scope :credited, lambda { where(status: 'credited') }
  scope :sampled, lambda { where(status: 'sampled') }
  scope :returned, lambda { where(status: 'returned') }

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :credited
    state :sampled
    state :returned

    event :submit do
      transitions :from => :draft, :to => :sold, after: :update_inventory #SALE
    end

    event :credit do
      transitions :from => :draft, :to => :credited, after: :update_inventory #SALE
    end

    event :sample do
      transitions :from => :draft, :to => :sampled, after: :update_inventory #SALE
    end

    event :reject do
      transitions :from => [:sold,:credited,:sampled], :to => :draft, after: :update_inventory #ADMIN
    end

    event :return_item do
      transitions :from => [:sold,:accepted], :to => :returned, after: [:minus_qty, :update_inventory]
    end
  end


  def self.sold_by_store_and_item(store_id,item_id)
    includes(:sale,:item,{sale:[:customer]},:return_items).
        where(sales:{store:store_id},item_id:item_id,status: 'sold')
  end

  def self.json_options
    {
        include: {
            item: {
                only: [:id,:name,:description,:original_number,:item_number]
            }
        },
        only:[:id,:qty,:unit_price,:status]
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
            },
            return_items: {
                only: [:id,:qty,:created_at,:note]
            }
        },
        methods: [:total_returned_qty],
        only: [:id,:qty,:unit_price]
    }
  end

  def total_returned_qty
    return_items.sum(:qty)
  end

  private
    def set_unit_price
      self.unit_price = item.sale_price if self.unit_price.nil? || self.unit_price == 0
    end

    def minus_qty
      self.qty = self.qty * -1
    end

    def update_inventory
      item.decrement!(self.sale.store.to_sym,qty)
    end

end
