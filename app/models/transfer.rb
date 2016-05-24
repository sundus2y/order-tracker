class Transfer < ActiveRecord::Base
  enum from_store: [:t_shop, :l_shop, :l_store]
  enum to_store: [:t_shop, :l_shop, :l_store]

  has_many :transfer_items
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id

  validates_presence_of :sender_id, :from_store, :to_store

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sent, lambda { where(status: 'sent') }
  scope :received, lambda { where(status: 'received') }

  default_scope { includes(:transfer_items).reorder(created_at: :desc)}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sent
    state :received

    event :submit, after: :submit_transfer_items do
      transitions :from => :draft, :to => :sent, unless: :empty_transfer_item? #SALE
      transitions :from => :sent, :to => :received, unless: :empty_transfer_item? #SALE
    end

  end

  def self.get_all_states
    aasm.states.map(&:name).map(&:to_s).map(&:upcase)
  end

  # def as_json(options={})
  #   type = options.delete(:type) || :default
  #   case type
  #     when :search
  #       super({
  #                 only: [:id,:created_at],
  #                 methods: [:grand_total,:status_upcase],
  #                 include: {
  #                     customer: {
  #                         only: [:name]
  #                     }
  #                 }
  #             }.merge(options))
  #     when :sale_items
  #       super({
  #                 include: {
  #                     sale_items: SaleItem.json_options
  #                 },
  #                 only: [:id]
  #             }.merge(options))
  #     when :default
  #       super options
  #   end
  # end

  def status_upcase
    status.upcase
  end

  private
  def submit_transfer_items
    transfer_items.map(&:submit!)
  end

  def empty_transfer_item?
    return true if transfer_items_count == 0
    transfer_items.where(qty: 0).count == 0 ? false : true
  end

end
