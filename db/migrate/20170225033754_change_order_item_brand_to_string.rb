class ChangeOrderItemBrandToString < ActiveRecord::Migration
  def change
    change_column :order_items, :brand, :string
    change_column :orders, :brand, :string
  end
end
