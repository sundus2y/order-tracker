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
    worksheet.merge_range('A1:Q1','Inventory for All Stores', heading_format)
    worksheet.write(1,0,'No',table_heading_format)
    write_item_header(table_heading_format, worksheet)
    start_index = 10
    Store.minus_virtual.each_with_index do |store,index|
      worksheet.write(1,start_index+index,store.name.titleize.upcase,table_heading_format)
      store_column_map[store.id] = start_index+index
    end
    item_inv = includes(:item).group_by{|inv| [inv.item_id]}
    item_inv.each_with_index do |(key,invs),index|
      begin
        worksheet.write(index+2,0,index+1)
        write_item_cell(index+2, invs[0].item, worksheet)
        invs.each_with_index do |inv,i|
          worksheet.write_number(index+2,store_column_map[inv.store_id],inv.qty || 0) if store_column_map[inv.store_id]
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
    write_item_header(table_heading_format, worksheet)
    worksheet.write(1,10,'Qty',table_heading_format)
    item_inv = includes(:item).where(store: store)
    item_inv.each_with_index do |inv, index|
      begin
        worksheet.write(index+2,0, index+1)
        debugger if inv.item.item_number == '5466025750'
        write_item_cell(index+2, inv.item, worksheet)
        worksheet.write_number(index+2,10, inv.qty || 0)
      rescue Exception => e
      end
    end
    workbook.close
    File.open("tmp/#{store.name} Inventory.xlsx").path
  end


private

  def self.write_item_header(table_heading_format, worksheet)
    worksheet.write(1, 1, 'Item Name', table_heading_format)
    worksheet.write(1, 2, 'Item Number', table_heading_format)
    worksheet.write(1, 3, 'Original Number', table_heading_format)
    worksheet.write(1, 4, 'Brand', table_heading_format)
    worksheet.write(1, 5, 'Made', table_heading_format)
    worksheet.write(1, 6, 'Dubai Price', table_heading_format)
    worksheet.write(1, 7, 'Korea Price', table_heading_format)
    worksheet.write(1, 8, 'Cost Price', table_heading_format)
    worksheet.write(1, 9, 'Sale Price', table_heading_format)
  end

  def self.write_item_cell(row, item, worksheet)
    worksheet.write_string(row, 1, item.name)
    worksheet.write_string(row, 2, item.item_number)
    worksheet.write_string(row, 3, item.original_number)
    worksheet.write_string(row, 4, item.brand)
    worksheet.write_string(row, 5, item.made)
    worksheet.write_number(row, 6, item.dubai_price || 0.00)
    worksheet.write_number(row, 7, item.korea_price || 0.00)
    worksheet.write_number(row, 8, item.cost_price || 0.00)
    worksheet.write_number(row, 9, item.sale_price || 0.00)
  end

end