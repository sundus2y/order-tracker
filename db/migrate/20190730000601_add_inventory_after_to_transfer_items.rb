class AddInventoryAfterToTransferItems < ActiveRecord::Migration
  def change
    add_column :transfer_items, :inventory_after, :integer
  end
end
