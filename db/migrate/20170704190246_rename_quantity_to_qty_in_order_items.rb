class RenameQuantityToQtyInOrderItems < ActiveRecord::Migration
  def change
    rename_column :order_items, :quantity, :qty
  end
end
