class Item < ActiveRecord::Base
  include PgSearch

  has_many :order_items, dependent: :destroy
  has_many :sale_items, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :transfer_items, dependent: :destroy

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
  before_save :update_default_sale_price
  after_save :invalidate_cache
  validates :name, presence: true
  validates :original_number, presence: true
  validates :original_number, uniqueness: {scope: [:item_number, :brand, :made]}
  validate :item_numbers_cannot_include_special_characters

  default_scope { includes(:inventories,{inventories:[:store]})}

  # INVALID_CHARS = %w(, . - _ : | \\ /)
  # INVALID_CHARS_REGEX = Regexp.new('\W')

  def as_json(options={})
    type = options.delete(:type) || :default
    case type
      when :search
        super({
                  only: [:id,:name,:original_number,:item_number,:prev_number,:next_number, :cost_price,
                        :description,:car,:model,:sale_price,:korea_price,:dubai_price,:brand,:made,:default_sale_price],
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
        <div class="container search-item dropdown-menu">
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
    error_list = []
    update_list = []
    to_import = []
    header = %w(model item_number original_number prev_number next_number name description car part_class korea_price brand make_from make_to)
    header_hash = {} #"Model", "Item Number", "Original Number", "Prev Number", "Next Number", "Name", "Description", "Car", "Part Class", "Korea Price", "Brand", "Make From", "Make To"
    header.each{|k|header_hash[k] = k.titleize}
    sheets_count = workbook.sheets.count
    sheets_count.times do |index|
      puts "Sheet Number #{index} has #{workbook.sheet(index).count} items"
      to_import, to_update, error_data = write_to_db(header_hash, workbook, index)
      [*error_list,*error_data]
      [*update_list,*to_update]
    end
    Rails.logger.info "Errors Found" unless error_list.empty?
    Rails.logger.debug error_list.to_yaml unless error_list.empty?
    Rails.logger.info "Updates Found" unless update_list.empty?
    Rails.logger.debug update_list.to_yaml unless update_list.empty?
    new_records = to_import.empty? ? [] : where(original_number: to_import.map{|item| item['original_number']}[1..100])
    return update_list, new_records
  end

  def self.import_non_original(file)
    workbook = Roo::Spreadsheet.open(file.path)
    raw_data = []
    error_list = []
    header = %w(item_number original_number name qty made brand size description)
    header_hash = {}
    header.each{|k| header_hash[k] = k.titleize}
    workbook.sheet(0).each_with_index(header_hash) do |hash, index|
      if index > 0
        begin
          new_item = {}
          hash['item_number'] = hash['item_number'].to_i.to_s if hash['item_number'].class == Float
          hash['original_number'] = hash['original_number'].to_i.to_s if hash['original_number'].class == Float
          new_item['item_number'] = hash['item_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
          new_item['original_number'] = hash['original_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
          new_item['name'] = hash['name'].to_s.upcase
          new_item['made'] = hash['made'].to_s.upcase
          new_item['brand'] = hash['brand'].to_s.upcase
          new_item['size'] = hash['size']
          new_item['description'] = hash['description'].to_s.gsub('/',"\n")
          raw_data << new_item
        rescue Exception => e
          error_list << hash
        end
      end
    end
    puts '.  Check for Original Items'
    existing_numbers = where(original_number: raw_data.map { |item| item['original_number'] }).pluck(:original_number)
    puts ".    Found #{existing_numbers.count} Original Items"
    clone_list, create_list = raw_data.partition { |item| existing_numbers.include? item['original_number'] }
    puts ".    Creating #{create_list.count} Items"
    create_non_original(create_list)
    puts ".    Done Creating #{create_list.count} Items"
    puts ".    Clone #{clone_list.count} Items"
    clone_new(clone_list)
    puts ".    Done Cloning #{clone_list.count} Items"
    return create_list, clone_list, error_list
  end

  def self.bulk_update(file,update_field)
    workbook = Roo::Spreadsheet.open(file.path)
    raw_data = []
    update_list = []
    error_list = []
    header = ['item_number', 'original_number', 'made', 'brand', update_field]
    header_hash = {}
    header.each{|k| header_hash[k] = k.titleize}
    workbook.sheet(0).each_with_index(header_hash) do |hash,index|
      if index > 0
        begin
          new_item = {}
          hash['item_number'] = hash['item_number'].to_i.to_s if hash['item_number'].class == Float
          hash['original_number'] = hash['original_number'].to_i.to_s if hash['original_number'].class == Float
          new_item['item_number'] = hash['item_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
          new_item['original_number'] = hash['original_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
          new_item['made'] = hash['made'].to_s.upcase
          new_item['brand'] = hash['brand'].to_s.upcase
          new_item[update_field] = hash[update_field]
          new_item['found'] = false
          raw_data << new_item
        rescue Exception => e
          error_list << hash
        end
      end
    end
    sql = []
    raw_data.each_with_index do |item|
      sql << "( item_number = '#{item['item_number']}' and
original_number = '#{item['original_number']}' and
made = '#{item['made']}' and
brand = '#{item['brand']}')"
    end
    items = Item.where(sql.join('or'))
    items.each do |item|
      raw_item = raw_data.select{ |i| item.item_number == i['item_number'] && item.original_number == i['original_number'] && item.made == i['made'] && item.brand == i['brand']}[0]
      raw_item['found'] = true
      begin
        item.update(update_field.to_sym => raw_item[update_field])
        update_list << item
      rescue Exception => e
        error_list << raw_item
      end
    end
    error_list += raw_data.select{|i| !i['found']}
    return update_list, error_list
  end

  def self.non_original_template
    workbook = WriteXLSX.new('tmp/non_original_template.xlsx')
    worksheet = workbook.add_worksheet
    header = %w(item_number original_number name qty made brand size description)
    header.map(&:titleize).each_with_index do |header,index|
      worksheet.write(0,index,header)
    end
    workbook.close
    File.open('tmp/non_original_template.xlsx').path
  end

  def self.write_to_db(header_hash, workbook, sheet)
    raw_data = []
    error_data = []
    workbook.sheet(sheet).each_with_index(header_hash) do |hash, index|
      begin
        hash['item_number'] = hash['item_number'].to_i.to_s if hash['item_number'].class == Float
        hash['original_number'] = hash['original_number'].to_i.to_s if hash['original_number'].class == Float
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
    puts '.  Check for Duplicate Items'
    duplicate_numbers = where(original_number: raw_data.map { |item| item['original_number'] }).pluck(:original_number)
    puts ".    Found #{duplicate_numbers.count} Duplicate Items"
    to_update, to_import = raw_data.partition { |item| duplicate_numbers.include? item['original_number'] }
    puts ".    Creating #{to_import.count} Items"
    create_new(to_import)
    puts ".    Done Creating #{to_import.count} Items"
    puts ".    Update #{to_update.count} Items"
    update_existing(to_update)
    puts ".    Done Updating #{to_update.count} Items"
    return to_import, to_update, error_data
  end

  def self.build_search_query(params)
    query = []
    params[:item_number].gsub!(INVALID_CHARS_REGEX, '') if params[:item_number].present?
    params[:other_numbers].gsub!(INVALID_CHARS_REGEX, '') if params[:other_numbers].present?
    query.push("name ilike '%#{params[:name]}%'") if params[:name].present?
    query.push("item_number ilike '#{params[:item_number]}%'") if params[:item_number].present?
    if params[:other_numbers].present?
      query.push("(description ilike '%#{params[:other_numbers]}%' or "+
                  "prev_number ilike '#{params[:other_numbers]}%' or "+
                  "next_number ilike '#{params[:other_numbers]}%' or "+
                  "original_number ilike '#{params[:other_numbers]}%')")
    end
    query.push("size ilike '%#{params[:size]}%'") if params[:size].present?
    query.push("car ilike '#{params[:car]}%'") if params[:car].present?
    query.push("brand ilike '#{params[:brand]}%'") if params[:brand].present?
    query.push("made ilike '#{params[:made]}%'") if params[:made].present?
    query.push("part_class ilike '#{params[:part_class]}%'") if params[:part_class].present?
    query.push(parse_price_string(params[:sale_price],'sale_price')) if params[:sale_price].present?
    query.push(parse_price_string(params[:dubai_price],'dubai_price')) if params[:dubai_price].present?
    query.push(parse_price_string(params[:korea_price],'korea_price')) if params[:korea_price].present?
    query.join(' and ')
  end

  def self.parse_price_string(str,field)
    return nil unless str
    operator = str.scan(/^[><=][=]{0,1}/).compact.reject(&:empty?).first
    val = str.scan(/\d*/).compact.reject(&:empty?).first
    return "#{field} #{operator||'='} #{val}"
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

  def transfer_log(log)
    t_items = transfer_items.includes(:transfer,transfer:[:to_store,:from_store])
    t_items.each do |t_item|
      t_in = Transaction.new(t_item.transfer.id,:transfer,t_item.qty,0,t_item.created_at,t_item.status)
      t_out = Transaction.new(t_item.transfer.id,:transfer,0,t_item.qty,t_item.created_at,t_item.status)
      log[t_item.transfer.to_store] ||= []
      log[t_item.transfer.to_store] << t_in
      log[t_item.transfer.from_store] ||= []
      log[t_item.transfer.from_store] << t_out
    end
    log
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
    inv.last.decrement!(:qty,qty) if direction == :down
    inv.last.increment!(:qty,qty) if direction == :up
    return inv.last
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

  def self.select_attributes
    %w(name description model car part_class make_from make_to
prev_number next_number sale_price dubai_price
korea_price default_sale_price size cost_price).map{|col| [col.titleize, col]}
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
    puts ".      #{inserts.count/500} Groups to Insert"
    inserts.in_groups_of(500).each_with_index do |group,index|
      group.compact!
      # puts "   Inserting Group ##{index} #{group.count} Items"
      unless group.empty?
        sql = "INSERT INTO Items (model,item_number,original_number,prev_number,next_number,name,description,car,part_class,dubai_price,brand,make_from,make_to,sale_price) VALUES #{group.join(", ")}"
        connection.execute sql unless new_records.empty?
      end
    end
    puts ".      #{inserts.count/500} Groups Inserted"
  end

  def self.create_non_original(new_records)
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
    puts ".      #{inserts.count/500} Groups to Insert"
    inserts.in_groups_of(500).each_with_index do |group,index|
      group.compact!
      # puts "   Inserting Group ##{index} #{group.count} Items"
      unless group.empty?
        sql = "INSERT INTO Items (item_number,original_number,name,made,brand,size,description) VALUES #{group.join(", ")}"
        connection.execute sql unless new_records.empty?
      end
    end
    puts ".      #{inserts.count/500} Groups Inserted"
  end

  def self.clone_new(clone_records)
    original_records = where(original_number: clone_records.map { |item| item['original_number'] })
    clone_records.each do |clone_record|
      cloned = original_records.select{|o_record| o_record.original_number == clone_record['original_number']}.first.dup
      cloned.item_number = clone_record['item_number']
      cloned.made = clone_record['made']
      cloned.brand = clone_record['brand']
      cloned.size = clone_record['size']
      cloned.description = clone_record['description']
      cloned.sale_price = cloned.korea_price = cloned.dubai_price = 0
      cloned.save
    end
  end

  def invalidate_cache
    @@cars = nil
    @@part_classes = nil
    @@brands = nil
    @@mades = nil
  end

  def update_default_sale_price
    self.default_sale_price = false if sale_price_changed?
    true
  end

  def self.update_existing(dup_records)
    puts ".      #{dup_records.count/1000} Groups to Update"
    dup_records.in_groups_of(1000).each_with_index do |group, index|
      group.compact!
      # puts ".      Group #{index+1} - Updating #{group.count} Items "
      _items = Item.where(original_number: group.map{|i| i['original_number']}).sort_by{|item| item.original_number}
      group.sort_by!{|item| item['original_number']}
      group.zip(_items).each do |item,_item|
        _item.update_attribute(:dubai_price, item['korea_price'])
      end
      # puts ".      Group #{index+1} - Done Updating"
    end
    puts ".      #{dup_records.count/1000} Groups Updated"
  end

end
