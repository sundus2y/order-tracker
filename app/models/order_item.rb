class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  BRANDS = ['Mobis','GM','NG']

  include AASM

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :ready
    state :accepted
    state :rejected

    event :submit do
      transitions :from => :draft, :to => :ordered
      transitions :from => :ordered, :to => :ready
      transitions :from => :ready, :to => :ready
      transitions :from => :ready, :to => :ship
      transitions :from => :ship, :to => :shipped
      transitions :from => :shipped, :to => :received
    end

    event :reject do
      transitions :from => :ship, :to => :draft
    end
  end

  def item_name
    item.try(:name)
  end

  def item_number
    item.try(:item_number)
  end

  def item_name=(name)
    if name.present?
      found_item = Item.where(name: name).first
      found_item ||= Item.create(name: name)
      self.item = found_item
    end
  end

  def total_price
    unit_price.try(:*,quantity)
  end

  def self.find_duplicate(item_id)
    OrderItem.where("status != :status and item_id = :item_id",status:'received',item_id:item_id).first
  end
end
