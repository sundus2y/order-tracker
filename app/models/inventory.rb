class Inventory < ActiveRecord::Base

  belongs_to :store
  belongs_to :item

  def update_location(loc)
    update_attribute(:location,loc)
  end

  def self.download
    workbook = WriteXLSX.new('tmp/inventory.xlsx')
    worksheet = workbook.add_worksheet
    worksheet.write(0,0,'No')
    worksheet.write(0,1,'Item Name')
    worksheet.write(0,2,'Original Number')
    worksheet.write(0,3,'Main Store')
    worksheet.write(0,4,'L Store')
    worksheet.write(0,5,'L Shop')
    worksheet.write(0,6,'T Shop')
    item_inv = includes(:item).group_by{|inv| [inv.item_id]}
    item_inv.each_with_index do |(key,invs),index|
      worksheet.write(index+1,0,index+1)
      worksheet.write(index+1,1,invs[0].item.name)
      worksheet.write(index+1,2,invs[0].item.original_number)
      invs.each do |inv|
        case inv.store_id
          when 8
            worksheet.write(index+1,3,inv.qty)
          when 6
            worksheet.write(index+1,4,inv.qty)
          when 5
            worksheet.write(index+1,5,inv.qty)
          when 4
            worksheet.write(index+1,6,inv.qty)
        end
      end
    end
    workbook.close
    File.open('tmp/inventory.xlsx').path
  end

end