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
  before_destroy :can_be_deleted?
  after_save :invalidate_cache
  validates :name, presence: true
  validates :original_number, presence: true
  validates :original_number, uniqueness: {scope: [:item_number, :brand, :made]}
  validate :item_numbers_cannot_include_special_characters

  default_scope { includes(:inventories,{inventories:[:store]})}

  INVALID_CHARS = %w(, . - _ : | \\ /)
  INVALID_CHARS_REGEX = Regexp.new('\W')

  def as_json(options={})
    type = options.delete(:type) || :default
    case type
      when :search
        super({
                  only: [:id,:name,:original_number,:item_number,:prev_number,:next_number,
                        :description,:car,:model,:sale_price,:brand,:made],
                  methods: [:actions,:inventories_display]
              }.merge(options))
      when :default
        super options
    end
  end

  def actions
    url_helpers = Rails.application.routes.url_helpers
    actions = <<-HTML
      <div class="btn-group btn-block">
        <button type="button" class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Actions <span class="caret"></span>
        </button>
        <div class="container dropdown-menu">
          <div class="row">
            <div class="col-md-12">
              <div class="row">
                <div class="col-md-4 menu-item">
                  <a class='btn btn-block btn-info btn-sm fa fa-eye action pop_up' role='button' href='#{url_helpers.item_pop_up_show_path self}'> View</a>
                </div>
                <div class="col-md-4 menu-item">
                  <a class='btn btn-block btn-success btn-sm fa fa-pencil pop_up' role='button' href='#{url_helpers.item_pop_up_edit_path self}'> Edit</a>
                </div>
                <div class="col-md-4 menu-item">
                  <a class='btn btn-block btn-warning btn-sm fa fa-trash' href='#{url_helpers.item_path self}' data-confirm='Are you sure?' data-method='delete' rel='nofollow'> Delete</a>
                </div>
              </div>
          </div>
        </div>
      </div>
    HTML
    actions.html_safe
  end

  def inventories_display
    response = []
    sep = '<br>'.html_safe
    inventories.each do |inventory|
      response << "#{inventory.store.short_name}: #{inventory.qty}" unless inventory.store.virtual?
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
    header = %w(model item_number original_number prev_number next_number name description car part_class korea_price brand make_from make_to)
    header_hash = {} #"Model", "Item Number", "Original Number", "Prev Number", "Next Number", "Name", "Description", "Car", "Part Class", "Korea Price", "Brand", "Make From", "Make To"
    header.each{|k|header_hash[k] = k.titleize}
    sheets_count = workbook.sheets.count
    sheets_count.times do |index|
      puts "Sheet Number #{index} has #{workbook.sheet(index).count} items"
      to_import, to_update, error_data = write_to_db(header_hash, workbook, index)
      puts "Done importing #{to_import.count} items"
    end
    updated = update_existing(to_update)
    new_records = to_import.empty? ? [] : where(original_number: to_import.map{|item| item['original_number']}[1..100])
    return updated, new_records
  end

  def self.write_to_db(header_hash, workbook, sheet)
    raw_data = []
    error_data = []
    workbook.sheet(sheet).each_with_index(header_hash) do |hash, index|
      begin
        hash['original_number'] = hash['original_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
        # TODO Add this back once initial import is done.
        # hash['item_number'] = hash['item_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
        hash['item_number'] = hash['original_number']
        hash['prev_number'] = hash['prev_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
        hash['next_number'] = hash['next_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
        hash['name'] = hash['name'].to_s.upcase
        hash['korea_price'] = ((hash['korea_price'] || 0).to_f * KRW_XE_USD).to_i
        hash['sale_price'] = (((hash['korea_price'] || 0).to_f * USD_XE_ETB * 4)).to_i
        hash['make_from'] = Date.parse(hash['make_from']) unless hash['make_from'].nil?
        hash['make_to'] = Date.parse(hash['make_to']) unless hash['make_to'].nil?
        hash['car'] = hash['car'].to_s.upcase
        hash['model'] = hash['model'].to_s.upcase
        hash['brand'] = case hash['brand'].to_s
                          when 'K', 'k', 'Kia'
                            'KIA'
                          when 'H', 'h', 'Hyundai'
                            'HYUNDAI'
                          else
                            hash['brand'].to_s.upcase
                        end
        raw_data << hash
      rescue Exception => e
        error_data << hash
      end
    end
    duplicate_numbers = where(original_number: raw_data.map { |item| item['original_number'] }).pluck(:original_number)
    to_update, to_import = raw_data.partition { |item| duplicate_numbers.include? item['original_number'] }
    create_new(to_import)
    Rails.logger.info "Errors Found" unless error_data.empty?
    Rails.logger.debug error_data.to_yaml unless error_data.empty?
    return to_import, to_update, error_data
  end

  def self.build_search_query(params)
    query = []
    query.push("name ilike '%#{params[:name]}%'") if params[:name].present?
    query.push("description ilike '#{params[:description]}'") if params[:description].present?
    query.push("item_number ilike '#{params[:item_number]}%'") if params[:item_number].present?
    if params[:other_numbers].present?
      query.push("(prev_number ilike '#{params[:other_numbers]}%' or "+
                  "next_number ilike '#{params[:other_numbers]}%' or "+
                  "original_number ilike '#{params[:other_numbers]}%')")
    end
    query.push("car ilike '#{params[:car]}%'") if params[:car].present?
    query.push("brand ilike '#{params[:brand]}%'") if params[:brand].present?
    query.push("made ilike '#{params[:made]}%'") if params[:made].present?
    query.push("part_class ilike '#{params[:part_class]}%'") if params[:part_class].present?
    query.push(parse_price_string(params[:sale_price])) if params[:sale_price].present?
    query.push(parse_price_string(params[:dubai_price])) if params[:dubai_price].present?
    query.join(' and ')
  end

  def self.parse_price_string(str)
    return nil unless str
    operator = str.scan(/^[><=][=]{0,1}/).compact.reject(&:empty?).first
    val = str.scan(/\d*/).compact.reject(&:empty?).first
    return "sale_price #{operator||'='} #{val}"
  end

  def self.fetch_cars
    @@cars ||= Item.uniq.select(:car).reorder(:car).map(&:car).compact.sort
    @@cars
  end

  def self.fetch_part_classes
    @@part_classes ||= Item.uniq.select(:part_class).map(&:part_class).compact.sort
    @@part_classes
  end

  def self.fetch_brands
    @@brands ||= Item.uniq.select(:brand).map(&:brand).compact.sort
    @@brands
  end

  def self.fetch_mades
    @@mades ||= Item.uniq.select(:made).map(&:made).compact.sort
    @@mades
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

  def update_inventory(store, qty, direction = :down)
    inv = inventories.where(store: store)
    if inv.empty?
      inv.create(qty: 0,store: store)
    end
    inv.reload.last.decrement!(:qty,qty) if direction == :down
    inv.reload.last.increment!(:qty,qty) if direction == :up
  end

  def label
    "#{name} - (#{original_number})"
  end

  def self.search_item2(term)
    if (term.count('1234567890').to_f/term.length) > 0.7
      includes(:sale_items,:order_items).where('prev_number ilike :term or ' +
                                               'next_number ilike :term or ' +
                                               'item_number ilike :term or ' +
                                               'original_number ilike :term', term: "#{term}%").reorder('original_number').limit(20)
    else
      includes(:sale_items,:order_items).where('name ilike :term or ' +
                                               'description ilike :term', term: "%#{term}%").reorder('name').limit(20)
    end
  end

private
  def self.create_new(new_records)
    inserts = []
    new_records.each do |item|
      inserts << "(#{item.values.map do |v|
        new_val = sanitize(v.to_s)
        if new_val == "''"
          "NULL"
        else
          new_val
        end
      end.join(',')})"
    end
    inserts.in_groups_of(5000).each do |group|
      unless group.compact.empty?
        sql = "INSERT INTO Items (model,item_number,original_number,prev_number,next_number,name,description,car,part_class,korea_price,brand,make_from,make_to,sale_price) VALUES #{group.compact.join(", ")}"
        connection.execute sql unless new_records.empty?
      end
    end
  end

  def invalidate_cache
    @@cars = nil
    @@part_classes = nil
    @@brands = nil
    @@mades = nil
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
