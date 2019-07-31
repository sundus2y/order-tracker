class Transfer < ActiveRecord::Base
  acts_as_paranoid

  has_many :transfer_items
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id, optional: true
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id, optional: true
  belongs_to :from_store, class_name: 'Store', foreign_key: :from_store_id
  belongs_to :to_store, class_name: 'Store', foreign_key: :to_store_id

  validates_presence_of :sender_id, :from_store_id, :to_store_id

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sent, lambda { where(status: 'sent') }
  scope :received, lambda { where(status: 'received') }

  before_create :set_sent_date

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sent
    state :received

    event :submit, after: :submit_transfer_items do
      transitions :from => :draft, :to => :sent, after: :set_sent_date, unless: :empty_transfer_item? #SALE
      transitions :from => :sent, :to => :received, after: :set_received_date, unless: :empty_transfer_item? #SALE
    end

  end

  def self.get_all_states
    aasm.states.map(&:name).map(&:to_s).map(&:upcase)
  end

  def self.search(query)
    search_query = all.includes(:from_store,:to_store,:sender,:receiver,:transfer_items)
    search_query = search_query.where(id: query[:id]) if query[:id].present?
    search_query = search_query.where(from_store_id: query[:from_store_id]) if query[:from_store_id].present?
    search_query = search_query.where(to_store_id: query[:to_store_id]) if query[:to_store_id].present?
    search_query = search_query.where(status: query[:status].downcase) if query[:status].present?
    if query[:date_from].present?
      search_query  = search_query.where("created_at >= '#{query[:date_from]}'")
      search_query = search_query.where("created_at <= '#{query[:date_to]}'") if query[:date_to].present?
    end
    search_query
  end

  def status_upcase
    status.upcase
  end

  private
  def submit_transfer_items
    transfer_items.map(&:submit!)
  end

  def set_sent_date
    self.sent_date ||= DateTime.now
  end

  def set_received_date
    self.received_date ||= DateTime.now
  end

  def empty_transfer_item?
    return true if transfer_items_count == 0
    transfer_items.where(qty: 0).count == 0 ? false : true
  end

end
