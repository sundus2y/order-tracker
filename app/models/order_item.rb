class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  BRANDS = ['Mobis','GM','NG']

  include AASM

  default_scope {includes(:item)}
  scope :draft, lambda { where(status: 'draft')}
  scope :ordered, lambda { where(status: 'ordered')}
  scope :ready, lambda { where(status: 'ready')}
  scope :accepted, lambda { where(status: 'accepted')}
  scope :rejected, lambda { where(status: 'rejected')}


  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :ordered
    state :ready
    state :accepted
    state :rejected

    event :submit do
      transitions :from => :draft, :to => :ordered
      transitions :from => :ordered, :to => :ready
      transitions :from => :ready, :to => :ship
      transitions :from => :ship, :to => :shipped
      transitions :from => :shipped, :to => :received
    end

    event :reject do
      transitions :from => [:ordered,:ready,:ship,:shipped,:received], :to => :draft
    end
  end

  def item_name
    item.try(:name)
  end

  def item_number
    item.try(:item_number)
  end

  def original_number
    item.try(:original_number)
  end

  def description
    item.try(:description)
  end

  def item_name=(name)
    if name.present?
      found_item = Item.where(name: name).first
      found_item ||= Item.create(name: name)
      self.item = found_item
    end
  end

  def status_upcase
    status.upcase
  end

  def total_price
    unit_price.try(:*,quantity)
  end

  def self.find_duplicates(item_ids,brand,order_id)
    query = <<-SQL
order_items.status != :status and item_id in (:item_id) and orders.brand = :brand and orders.id != :order_id
    SQL
    found_order_items = OrderItem.joins(:order).where(query,
                                  status:'received',
                                  item_id:item_ids,
                                  brand: brand,
                                  order_id: order_id)
  end
end
