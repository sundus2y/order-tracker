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

  def self.import(file)
    workbook = Roo::Spreadsheet.open(file.path)
    header = {name: "Name", description: "Description", item_number: "Item Number"}
    duplicate = []
    workbook.sheet(0).each_with_index(header) do |hash,index|
      if index>1
        item = new(hash)
        duplicate << item unless item.save
      end
    end
    duplicate
  end

  def to_s
    "#{item_number} |  #{name}"
  end

end
