class Sale < ActiveRecord::Base
  enum store: [:t_shop, :l_shop, :l_store]

  has_many :sale_items
  belongs_to :customer

  validates_presence_of :customer_id, :store, :created_at

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sold, lambda { where(status: 'sold') }
  scope :credited, lambda { where(status: 'credited') }
  scope :sampled, lambda { where(status: 'sampled') }
  scope :returned, lambda { where(status: 'returned') }

  default_scope { includes(:sale_items).reorder(created_at: :asc)}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sold
    state :credited
    state :sampled
    state :returned

    event :submit, after: :submit_sale_items do
      transitions :from => :draft, :to => :sold, unless: :empty_sale_item? #SALE
    end

    event :credit, after: :credit_sale_items do
      transitions :from => :draft, :to => :credited, unless: :empty_sale_item? #SALE
    end

    event :sample, after: :sample_sale_items do
      transitions :from => :draft, :to => :sampled, unless: :empty_sale_item? #SALE
    end

    event :reject, after: :reject_sale_items do
      transitions :from => [:sold,:credited,:sampled], :to => :draft #ADMIN
    end

    event :return_sale do
      transitions :from => [:sold,:accepted], :to => :returned, if: :empty_sold_item?
    end
  end

  def self.get_all_states
    aasm.states.map(&:name).map(&:to_s).map(&:upcase)
  end

  def self.all_grouped_by_store
    result = all.group_by(&:store)
    result.default = []
    result
  end

  def self.search(query)
    search_query = all
    search_query = search_query.where(customer_id: query[:customer_id]) if query[:customer_id].present?
    search_query = search_query.where(status: query[:status].downcase) if query[:status].present?
    if query[:date_from].present?
      search_query  = search_query.where("created_at >= '#{query[:date_from]}'")
      search_query = search_query.where("created_at <= '#{query[:date_to]}'") if query[:date_to].present?
    end
    search_query
  end

  def as_json(options={})
    type = options.delete(:type) || :default
    case type
      when :search
        super({
                  only: [:id,:created_at],
                  methods: [:grand_total,:status_upcase],
                  include: {
                      customer: {
                          only: [:name]
                      }
                  }
              }.merge(options))
      when :sale_items
        super({
                  include: {
                      sale_items: SaleItem.json_options
                  },
                  only: [:id]
              }.merge(options))
      when :default
        super options
    end
  end

  def status_upcase
    status.upcase
  end

  def grand_total
    sale_items.inject(0){|n,sale_item| n + (sale_item.qty*sale_item.unit_price)}
  end

  private
    def submit_sale_items
      sale_items.map(&:submit!)
    end

    def reject_sale_items
      sale_items.map(&:reject!)
    end

    def credit_sale_items
      sale_items.map(&:credit!)
    end

    def sample_sale_items
      sale_items.map(&:sample!)
    end

    def empty_sale_item?
      return true if sale_items_count == 0
      sale_items.where('qty = 0 OR unit_price = 0').count == 0 ? false : true
    end

    def empty_sold_item?
      sold_count = sale_items.where(status: 'sold').sum(:qty)
      returned_count = sale_items.where(status: 'returned').sum(:qty)
      sold_count + returned_count == 0 ? true : false
    end

end
