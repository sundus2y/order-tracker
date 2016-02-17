class AddBrandToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :brand, :string
  end
end
