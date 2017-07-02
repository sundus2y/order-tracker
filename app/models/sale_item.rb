class SaleItem < ActiveRecord::Base

  belongs_to :sale, :counter_cache => true
  belongs_to :item
  has_many :return_items, dependent: :destroy

  before_create :set_unit_price
  after_save :recal_grand_total

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sold, lambda { where(status: 'sold') }
  scope :credited, lambda { where(status: 'credited') }
  scope :sampled, lambda { where(status: 'sampled') }
  scope :returned, lambda { where(status: 'returned') }
  scope :void, lambda { where(status: 'void') }

  # default_scope { reorder(updated_at: :desc)}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :credited
    state :sampled
    state :returned
    state :void

    event :submit do
      transitions :from => :draft, :to => :sold, after: :update_inventory #SALE
    end

    event :mark_as_sold do
      transitions :from => [:sampled,:credited], :to => :sold #SALE
    end

    event :credit do
      transitions :from => :draft, :to => :credited, after: :update_inventory #SALE
    end

    event :sample do
      transitions :from => :draft, :to => :sampled, after: :update_inventory #SALE
    end

    event :reject do
      transitions :from => [:sold,:credited,:sampled], :to => :void, after: [:minus_qty, :update_inventory] #ADMIN
    end

    event :delete_draft do
      transitions :from => :draft, :to => :void
    end

    event :return_item do
      transitions :from => [:sold,:credited,:sampled], :to => :returned, after: [:minus_qty, :update_inventory]
    end
  end


  def self.by_store_and_item(store_id,item_id)
    includes(:sale,:item,{sale:[:customer]},:return_items).
        where(sales:{store_id:store_id},item_id:item_id,status: %w(sold credited sampled))
  end

  def total_returned_qty
    return_items.sum(:qty)
  end

  private
    def set_unit_price
      self.unit_price = item.sale_price if unit_price.nil? || unit_price == 0
    end

    def minus_qty
      update_attribute(:qty, qty*-1)
    end

    def update_inventory
      item.update_inventory(sale.store, qty)
    end

    def recal_grand_total
      sale.save!
    end

end
