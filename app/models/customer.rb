class Customer < ActiveRecord::Base
  enum category: [:retail, :wholesale, :company]

  has_many :sales, dependent: :destroy
  has_many :proformas, dependent: :destroy
  has_many :cars

  accepts_nested_attributes_for :cars, allow_destroy: true

  validates_presence_of :name, :phone
  validates_uniqueness_of :tin_no, if: Proc.new { |customer| customer.new_record? && customer.tin_no != '0' }
  validates_uniqueness_of :phone, if: Proc.new { |customer| customer.new_record? }

  before_save :upcase_fields

  KEY_MAP = {'regular_actions' => 'actions', 'admin_actions' => 'actions'}

  def as_json(options={})
    type = options.delete(:type) || :default
    case type
      when :admin_search
        super({
                  only: [:id,:name,:company,:phone,:category,:tin_no],
                  methods: [:admin_actions]
              }.merge(options))
      when :regular_search
        super({
                  only: [:id,:name,:company,:phone,:category,:tin_no],
                  methods: [:regular_actions]
              }.merge(options))
      when :default
        super options
    end
  end

  def self.search(query)
    search_query = all.includes(:sales)
    search_query = search_query.where(id: query[:id]) if query[:id].present?
    search_query = search_query.where("LOWER(name) like LOWER('#{query[:name]}%')") if query[:name].present?
    search_query = search_query.where("LOWER(company) like LOWER('#{query[:company]}%')") if query[:company].present?
    search_query = search_query.where(phone: query[:phone]) if query[:phone].present?
    search_query = search_query.where("tin_no like '#{query[:tin_no]}%'") if query[:tin_no].present?
    search_query
  end

  def autocomplete_display
    str = "".html_safe
    str << "<div class='row'>".html_safe
    str << "<div data-index='0'>#{name}</div>".html_safe
    str << "<div data-index='1'>#{company.present? ? company : 'Unknown'}</div>".html_safe
    str << "<div data-index='2'>#{phone.present? ? phone : 'Unknown'}</div>".html_safe
    str << "<div data-index='3'>#{tin_no.present? ? tin_no : 'Unknown'}</div>".html_safe
    str << "<div data-index='4'>#{category}</div>".html_safe
    str << "</div>".html_safe
  end

  def actions(type)
    url_helpers = Rails.application.routes.url_helpers
    view_action = "<li><a class='btn-primary pop_up item-pop-up-menu' href='#{url_helpers.customer_pop_up_show_path self}'><i class='fa fa-eye'></i> View</a></li>"
    edit_action = "<li><a class='btn-primary pop_up item-pop-up-menu' href='#{url_helpers.customer_pop_up_edit_path self}'><i class='fa fa-pencil'></i> Edit</a></li>"
    delete_action = "<li><a class='btn-danger item-pop-up-menu' href='#{url_helpers.customer_path self}' data-confirm='Are you sure?' data-method='delete' rel='nofollow'><i class='fa fa-trash'></i> Delete</a></li>"
    actions_html = <<-HTML
      <div class="btn-group">
        <a class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="#">
          Actions <span class="fa fa-caret-down" title="Toggle dropdown menu"></span>
        </a>
        <ul class="dropdown-menu context-menu">
          #{view_action}
          #{edit_action}
          #{delete_action if (type == :admin && (sales.count==0 && proformas.count==0))}
        </ul>
      </div>
    HTML
    actions_html.html_safe
  end

  def regular_actions
    actions(:regular)
  end

  def admin_actions
    actions(:admin)
  end

  def label
    name
  end

  def category_label
    category.upcase
  end

  def can_be_deleted?
    sales.empty?
  end

  private

  def upcase_fields
    self.name.upcase!
    self.company.upcase!
  end

end
