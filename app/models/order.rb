class Order < ActiveRecord::Base
  include AASM

  enum brand: [:mobis,:gm, :ng]


  default_scope {includes(:order_items).reorder(created_at: :desc)}
  scope :draft, lambda { where(status: 'draft') }
  scope :ordered, lambda { where(status: 'ordered') }
  scope :ready, lambda { where(status: 'ready') }
  scope :accepted, lambda { where(status: 'accepted') }
  scope :rejected, lambda { where(status: 'rejected') }
  scope :non_empty, lambda { where('order_items_count >= 1') }

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :ordered
    state :ready
    state :accepted
    state :rejected

    event :submit, after: :submit_order_items do
      transitions :from => :draft, :to => :ordered #ADMIN
      transitions :from => :ordered, :to => :ready #VENDOR
      transitions :from => :ready, :to => :ship #ADMIN
      transitions :from => :ship, :to => :shipped #VENDOR
      transitions :from => :shipped, :to => :received #ADMIN
    end

    event :reject, after: :reject_order_items do
      transitions :from => [:ordered,:ready,:ship,:shipped,:received], :to => :draft
    end
  end

  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda{|item_param| item_param[:quantity].blank? }

  validates :title, presence: true

  def grand_total
    order_items.map(&:total_price).compact.sum
  end

  def total_qty
    order_items.map(&:quantity).compact.sum
  end

  def status_upcase
    status.upcase
  end

  def status_class

  end

  private
    def submit_order_items
      order_items.map(&:submit!)
    end

    def reject_order_items
      order_items.map(&:reject!)
    end
end
