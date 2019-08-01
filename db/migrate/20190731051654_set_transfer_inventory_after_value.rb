class SetTransferInventoryAfterValue < ActiveRecord::Migration[5.2]
  def change
    transfer_items = TransferItem.where(inventory_after: nil)
    progressbar = ProgressBar.create(:title => "Transfer Inventory After", :starting_at => 0, :total => transfer_items.count, format: "%a %e %P% Processed: %c from %C")
    transfer_items.each do |transfer_item|
      sql = <<-SQL
SELECT *
FROM sale_items
INNER JOIN sales
ON sale_items.sale_id = sales.id
WHERE sales.store_id = #{transfer_item.transfer.to_store_id}
AND sale_items.item_id = #{transfer_item.item_id}
AND sales.created_at <= '#{transfer_item.created_at}'
      SQL
      sales_qty =  SaleItem.find_by_sql(sql).map(&:qty).sum

      sql =<<-SQL
SELECT *
FROM transfer_items
INNER JOIN transfers
ON transfer_items.transfer_id = transfers.id
WHERE transfers.to_store_id = #{transfer_item.transfer.to_store_id}
AND transfer_items.item_id = #{transfer_item.item_id}
AND transfers.created_at <= '#{transfer_item.created_at}'
      SQL
      transfers_in_qty = TransferItem.find_by_sql(sql).map(&:qty).sum
      sql =<<-SQL
SELECT *
FROM transfer_items
INNER JOIN transfers
ON transfer_items.transfer_id = transfers.id
WHERE transfers.from_store_id = #{transfer_item.transfer.to_store_id}
AND transfer_items.item_id = #{transfer_item.item_id}
AND transfers.created_at <= '#{transfer_item.created_at}'
      SQL
      transfers_out_qty = TransferItem.find_by_sql(sql).map(&:qty).sum
      # puts "#{transfer_item.created_at} - #{transfer_item.transfer.to_store.short_name} - #{transfers_in_qty - transfers_out_qty - sales_qty}"
      transfer_item.inventory_after = transfers_in_qty - transfers_out_qty - sales_qty
      transfer_item.save
      progressbar.increment
    end
  end
end
