class ChangeBrandType < ActiveRecord::Migration
  def change
    OrderItem.delete_all
    Order.delete_all
    change_column :orders, :brand, 'integer USING CAST("brand" AS integer)'
    change_column :order_items, :brand, 'integer USING CAST("brand" AS integer)'
  end
end
