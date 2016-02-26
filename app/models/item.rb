class Item < ActiveRecord::Base
  before_destroy :should_have_no_order_items
  validates :name, presence: true
  validates :original_number, presence: true
  validates :original_number, uniqueness: true

  def should_have_no_order_items
    return true if OrderItem.where(item:self).count == 0
    errors.add :item, "And Order exists with selected Item."
    false
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
      worksheet.write(row+1,3,item.original_number)
    end
    workbook.close
    File.open('tmp/all_items_export.xlsx').path
  end

  def self.import(file)
    workbook = Roo::Spreadsheet.open(file.path)
    header = {name: "Name", description: "Description", item_number: "Item Number", original_number: "Original Number"}
    raw_data = []
    workbook.sheet(0).each_with_index(header) do |hash,index|
      if index>=1
        raw_data << new(hash)
        raw_data.last.item_number = hash[:item_number].to_s.remove('.')
        raw_data.last.original_number = hash[:original_number].to_s.remove('.')
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

private
  def self.create_new(new_records)
    inserts = []
    new_records.each do |item|
      inserts << "(#{sanitize(item.name.to_s)},#{sanitize(item.description.to_s)},#{sanitize(item.item_number.to_s)},#{sanitize(item.original_number.to_s)})"
    end
    inserts.in_groups_of(10000).each do |group|
      unless group.compact.empty?
        sql = "INSERT INTO Items (name, description, item_number, original_number) VALUES #{group.compact.join(", ")}"
        connection.execute sql unless new_records.empty?
      end
    end
  end

  def self.update_existing(dup_records)
    _items = Item.where(original_number: dup_records.map(&:original_number)).sort_by{|item| item.original_number}
    dup_records.sort_by!{|item| item.original_number}
    dup_records.zip(_items).each do |item,_item|
      new_desc = "#{_item.description}\n#{item.original_number} #{item.name}".strip
      _item.update_attribute(:description, new_desc)
    end
    _items
  end

end
