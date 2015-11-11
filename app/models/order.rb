class Order < ActiveRecord::Base
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

  belongs_to :user
  has_many :order_items
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda{|item_param| item_param[:quantity].blank? }

  validates :title, presence: true

  def grand_total
    order_items.map(&:total_price).compact.sum
  end

  def total_qty
    order_items.map(&:quantity).compact.sum
  end

end
