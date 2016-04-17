class UpdateOrderItemAndSaleItemUnitPrice < ActiveRecord::Migration
  def change
    change_column :order_items, :unit_price, :float
    change_column :sale_items, :unit_price, :float
  end
end
