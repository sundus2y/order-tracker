class Item < ActiveRecord::Base
  before_destroy :should_have_no_order_items
  validates :name, presence: true
  validates :item_number, presence: true
  validates :item_number, uniqueness: true

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
    end
    workbook.close
    File.open('tmp/all_items_export.xlsx').path
  end

  def self.import(file)
    workbook = Roo::Spreadsheet.open(file.path)
    header = {name: "Name", description: "Description", item_number: "Item Number"}
    raw_data = []
    inserts = []
    workbook.sheet(0).each_with_index(header) do |hash,index|
      if index>=1
        raw_data << new(hash)
        raw_data.last.item_number = hash[:item_number].to_s.remove('.')
      end
    end
    duplicate_numbers = where(item_number: raw_data.map(&:item_number)).pluck(:item_number)
    duplicate_records = raw_data.select{|item| duplicate_numbers.include? item.item_number}
    to_import = raw_data.reject{|item| duplicate_numbers.include? item.item_number}
    to_import.each do |item|
      inserts << "(#{sanitize(item.name.to_s)},#{sanitize(item.description.to_s)},#{sanitize(item.item_number.to_s)})"
    end
    sql = "INSERT INTO Items (name, description, item_number) VALUES #{inserts.join(", ")}"
    inserts.in_groups_of(10000).each do |group|
      unless group.compact.empty?
        sql = "INSERT INTO Items (name, description, item_number) VALUES #{group.compact.join(", ")}"
        connection.execute sql unless to_import.empty?
      end
    end
    new_records = to_import.empty? ? [] : where(item_number: to_import.map(&:item_number)[1..100])
    return duplicate_records, new_records
  end

  def to_s
    "#{item_number} |  #{name}"
  end

end
