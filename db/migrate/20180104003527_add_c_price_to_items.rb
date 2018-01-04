class AddCPriceToItems < ActiveRecord::Migration
  def change
    add_column :items, :c_price, :decimal, precision: 11, scale: 2
  end
end
