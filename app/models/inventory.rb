class Inventory < ActiveRecord::Base

  belongs_to :store
  belongs_to :item

  def update_location(loc)
    update_attribute(:location,loc)
  end

  def self.download
    workbook = WriteXLSX.new('tmp/All Stores Inventory.xlsx')
    worksheet = workbook.add_worksheet
    store_column_map = {}
    heading_format = workbook.add_format(border: 6,bold: 1,color: 'red',align: 'center')
    table_heading_format = workbook.add_format(bold: 1)
    worksheet.merge_range('A1:P1','Inventory for All Stores', heading_format)
    worksheet.write(1,0,'No',table_heading_format)
    worksheet.write(1,1,'Item Name',table_heading_format)
    worksheet.write(1,2,'Item Number',table_heading_format)
    worksheet.write(1,3,'Original Number',table_heading_format)
    worksheet.write(1,4,'Brand',table_heading_format)
    worksheet.write(1,5,'Made',table_heading_format)
    worksheet.write(1,6,'Dubai Price', table_heading_format)
    worksheet.write(1,7,'Korea Price', table_heading_format)
    worksheet.write(1,8,'Cost Price', table_heading_format)
    worksheet.write(1,9,'Sale Price', table_heading_format)
    start_index = 10
    Store.minus_virtual.each_with_index do |store,index|
      worksheet.write(1,start_index+index,store.name.titleize.upcase,table_heading_format)
      store_column_map[store.id] = start_index+index
    end
    item_inv = includes(:item).group_by{|inv| [inv.item_id]}
    item_inv.each_with_index do |(key,invs),index|
      begin
        worksheet.write(index+2,0,index+1)
        worksheet.write_string(index+2,1,invs[0].item.name)
        worksheet.write_string(index+2,2,invs[0].item.item_number)
        worksheet.write_string(index+2,3,invs[0].item.original_number)
        worksheet.write_string(index+2,4,invs[0].item.brand)
        worksheet.write_string(index+2,5,invs[0].item.made)
        worksheet.write_number(index+2,6,invs[0].item.dubai_price)
        worksheet.write_number(index+2,7,invs[0].item.korea_price)
        worksheet.write_number(index+2,8,invs[0].item.cost_price)
        worksheet.write_number(index+2,9,invs[0].item.sale_price)
        invs.each_with_index do |inv,i|
          worksheet.write_number(index+2,store_column_map[inv.store_id],inv.qty) if store_column_map[inv.store_id]
        end
      rescue Exception => e
      end
    end
    workbook.close
    File.open('tmp/All Stores Inventory.xlsx').path
  end

  def self.download_by_store(store_id)
    store = Store.find(store_id.to_i)
    workbook = WriteXLSX.new("tmp/#{store.name} Inventory.xlsx")
    worksheet = workbook.add_worksheet
    heading_format = workbook.add_format(border: 6,bold: 1,color: 'red',align: 'center')
    table_heading_format = workbook.add_format(bold: 1)
    worksheet.merge_range('A1:K1', "Inventory for #{store.name}", heading_format)
    worksheet.write(1,0,'No',table_heading_format)
    worksheet.write_string(1,1,'Item Name',table_heading_format)
    worksheet.write_string(1,2,'Item Number',table_heading_format)
    worksheet.write_string(1,3,'Original Number',table_heading_format)
    worksheet.write_string(1,4,'Brand',table_heading_format)
    worksheet.write_string(1,5,'Made',table_heading_format)
    worksheet.write(1,6,'Dubai Price', table_heading_format)
    worksheet.write(1,7,'Korea Price', table_heading_format)
    worksheet.write(1,8,'Cost Price', table_heading_format)
    worksheet.write(1,9,'Sale Price', table_heading_format)
    worksheet.write(1,10,'Qty',table_heading_format)
    item_inv = includes(:item).where(store: store)
    item_inv.each_with_index do |inv, index|
      begin
        worksheet.write(index+2,0, index+1)
        worksheet.write(index+2,1, inv.item.name)
        worksheet.write_string(index+2,2, inv.item.item_number)
        worksheet.write_string(index+2,3, inv.item.original_number)
        worksheet.write_string(index+2,4, inv.item.brand)
        worksheet.write_string(index+2,5, inv.item.made)
        worksheet.write_number(index+2,6, inv.item.dubai_price)
        worksheet.write_number(index+2,7, inv.item.korea_price)
        worksheet.write_number(index+2,8, inv.item.cost_price)
        worksheet.write_number(index+2,9, inv.item.sale_price)
        worksheet.write_number(index+2,6, inv.qty)
      rescue Exception => e
      end
    end
    workbook.close
    File.open("tmp/#{store.name} Inventory.xlsx").path
  end

end