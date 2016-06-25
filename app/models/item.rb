class Item < ActiveRecord::Base
  include PgSearch

  has_many :order_items, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  has_many :inventories, dependent: :destroy

  accepts_nested_attributes_for :inventories, reject_if: proc {|attrib| attrib['qty'].blank? }

  pg_search_scope :search_item,
                  :against => {
                      original_number: 'A',
                      item_number: 'B',
                      name: 'C',
                      brand: 'D',
                      made: 'D'
                  },
                  :using => {
                      :trigram => {
                          threshold: 0.07
                      }
                  }
  before_destroy :should_have_no_order_items
  validates :name, presence: true
  validates :original_number, presence: true
  validates :original_number, uniqueness: {scope: [:item_number, :brand, :made]}
  validate :item_numbers_cannot_include_special_characters

  default_scope { includes(:inventories,{inventories:[:store]}).reorder(updated_at: :desc)}

  INVALID_CHARS = %w(, . - _ : | \\ /)
  INVALID_CHARS_REGEX = Regexp.new('\W')

  def should_have_no_order_items
    return true if OrderItem.where(item:self).count == 0
    errors.add :item, "And Order exists with selected Item."
    false
  end

  def as_json(options={})
    type = options.delete(:type) || :default
    case type
      when :search
        super({
                  only: [:name,:original_number,:item_number,:prev_number,:next_number,
                        :description,:car,:model,:sale_price,:dubai_price,:korea_price,
                        :brand,:made],
                  methods: [:actions,:inventories_display]
              }.merge(options))
      when :default
        super options
    end
  end

  def actions
    url_helpers = Rails.application.routes.url_helpers
    actions = []
    separator = '<br>'.html_safe
    actions <<  "<a class='btn btn-info btn-sm fa fa-eye action pop_up' role='button' href='#{url_helpers.item_pop_up_show_path self}'></a>"
    actions <<  "<a class='btn btn-success btn-sm fa fa-pencil pop_up' role='button' href='#{url_helpers.item_pop_up_edit_path self}'></a>"
    actions <<  "<a class='btn btn-warning btn-sm fa fa-trash' href='#{url_helpers.item_path self}' data-confirm='Are you sure?' data-method='delete' rel='nofollow'></a>" if self.can_be_deleted?
    actions.join(separator).html_safe
  end

  def inventories_display
    response = []
    sep = '<br>'.html_safe
    inventories.each do |inventory|
      response << "#{inventory.store.short_name}: #{inventory.qty}"
    end
    response.join(sep).html_safe
  end

  def can_be_deleted?
    order_items.empty? && sale_items.empty? && inventories.empty?
  end

  def item_numbers_cannot_include_special_characters
    error_msg = "can't include the following characters: (#{INVALID_CHARS.join(' ')} or space)"
    errors.add :original_number, error_msg if INVALID_CHARS_REGEX.match(original_number)
    errors.add :item_number, error_msg if INVALID_CHARS_REGEX.match(item_number)
    errors.add :prev_number, error_msg if INVALID_CHARS_REGEX.match(prev_number)
    errors.add :next_number, error_msg if INVALID_CHARS_REGEX.match(next_number)
  end

  def self.excel_template
    workbook = WriteXLSX.new('tmp/items_template.xlsx')
    worksheet = workbook.add_worksheet
    column_names.reject{|c|['created_at','updated_at'].include?c}.map(&:titleize).each_with_index do |header,index|
      worksheet.write(0,index,header)
    end
    workbook.close
    File.open('tmp/items_template.xlsx').path
  end

  def self.download
    workbook = WriteXLSX.new('tmp/all_items_export.xlsx')
    worksheet = workbook.add_worksheet
    column_names.reject{|c|['created_at','updated_at'].include?c}.map(&:titleize).each_with_index do |header,index|
      worksheet.write(0,index,header)
    end
    all.each_with_index do |item,row|
      worksheet.write(row+1,0,item.id)
      worksheet.write(row+1,1,item.name)
      worksheet.write(row+1,2,item.description)
      worksheet.write(row+1,3,item.item_number)
      worksheet.write(row+1,4,item.original_number)
      worksheet.write(row+1,5,item.model)
      worksheet.write(row+1,6,item.car)
      worksheet.write(row+1,7,item.part_class)
    end
    workbook.close
    File.open('tmp/all_items_export.xlsx').path
  end

  def self.import(file)
    workbook = Roo::Spreadsheet.open(file.path)
    header = {name: "Name",
              description: "Description",
              item_number: "Item Number",
              original_number: "Original Number",
              model: 'Model',
              car: 'Car',
              part_class: 'Part Class'}
    raw_data = []
    workbook.sheet(0).each_with_index(header) do |hash,index|
      if index>=1
        raw_data << new(hash)
        raw_data.last.item_number = hash[:item_number].to_s.gsub!(INVALID_CHARS_REGEX,'')
        raw_data.last.original_number = hash[:original_number].to_s.gsub!(INVALID_CHARS_REGEX,'')
      end
    end
    duplicate_numbers = where(original_number: raw_data.map(&:original_number)).pluck(:original_number)
    to_update, to_import = raw_data.partition{|item| duplicate_numbers.include? item.original_number}
    create_new(to_import)
    updated = update_existing(to_update)
    new_records = to_import.empty? ? [] : where(original_number: to_import.map(&:original_number)[1..100])
    return updated, new_records
  end

  def to_s
    "#{original_number} |  #{name}"
  end

  def sale_item_autocomplete_display
    str = "".html_safe
    str << "<div class='row'>".html_safe
    str << "<div data-index='0'>#{original_number}</div>".html_safe
    str << "<div data-index='1'>#{name}</div>".html_safe
    str << "<div data-index='2'>".html_safe
    inventories.each do |inv|
      str << "<span class='inventory'>#{inv.store.short_name}: #{inv.qty}</span>".html_safe
    end
    str << "</div>".html_safe
    str << "<div data-index='3'>#{brand.present? ? brand : 'Unknown'}</div>".html_safe
    str << "<div data-index='4'>#{made.present? ? made : 'Unknown'}</div>".html_safe
    str << "</div>".html_safe
  end

  def update_inventory(store, qty)
    inv = inventories.where(store: store)
    if inv.empty?
      inv.create(qty: 0,store: store)
    end
    inv.reload.last.decrement!(:qty,qty)
  end

  def label
    "#{name} - (#{original_number})"
  end

  def self.search_item2(term)
    includes(:sale_items,:order_items).where("LOWER(name) like LOWER(:term) or LOWER(item_number) like LOWER(:term) or LOWER(original_number) like LOWER(:term)", term: "%#{term}%").limit(20)
  end

private
  def self.create_new(new_records)
    inserts = []
    new_records.each do |item|
      inserts << "(#{sanitize(item.name.to_s)},
#{sanitize(item.description.to_s)},
#{sanitize(item.item_number.to_s)},
#{sanitize(item.original_number.to_s)},
#{sanitize(item.model.to_s)},
#{sanitize(item.car.to_s)},
#{sanitize(item.part_class.to_s)})"
    end
    inserts.in_groups_of(10000).each do |group|
      unless group.compact.empty?
        sql = "INSERT INTO Items (name, description, item_number, original_number, model, car, part_class) VALUES #{group.compact.join(", ")}"
        connection.execute sql unless new_records.empty?
      end
    end
  end

  def self.update_existing(dup_records)
    _items = Item.where(original_number: dup_records.map(&:original_number)).sort_by{|item| item.original_number}
    dup_records.sort_by!{|item| item.original_number}
    dup_records.zip(_items).each do |item,_item|
      new_desc = "#{_item.description}\n#{item.car} #{item.model}".strip
      _item.update_attribute(:description, new_desc)
    end
    _items
  end

end
