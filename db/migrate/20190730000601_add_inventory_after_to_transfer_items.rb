class AddInventoryAfterToTransferItems <  ActiveRecord::Migration[4.2]
  def change
    add_column :transfer_items, :inventory_after, :integer
  end
end
