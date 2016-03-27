class AddPriceAttributesToItem < ActiveRecord::Migration
  def change
    add_column :items, :sale_price, :float, default: 0.00
    add_column :items, :dubai_price, :float, default: 0.00
    add_column :items, :korea_price, :float, default: 0.00
  end
end
