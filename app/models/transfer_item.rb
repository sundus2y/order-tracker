class TransferItem < ActiveRecord::Base

  belongs_to :transfer, :counter_cache => true
  belongs_to :item

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sent, lambda { where(status: 'sent') }
  scope :received, lambda { where(status: 'received') }

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sent
    state :received

    event :submit do
      transitions :from => :draft, :to => :sent, after: :dec_inventory #SALE
      transitions :from => :sent, :to => :received, after: :inc_inventory #SALE
    end

  end

  private

  def dec_inventory
    item.update_inventory(transfer.from_store,qty)
  end

  def inc_inventory
    item.update_inventory(transfer.to_store,qty,:up).update_location(location)
  end

end
