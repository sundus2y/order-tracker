class AddBrandToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :brand, :string
  end
end
