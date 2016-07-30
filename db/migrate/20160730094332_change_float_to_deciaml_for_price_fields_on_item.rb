class ChangeFloatToDeciamlForPriceFieldsOnItem < ActiveRecord::Migration
  def change
    change_column :items, :sale_price, :decimal, precision: 11, scale: 2
    change_column :items, :dubai_price, :decimal, precision: 11, scale: 2
    change_column :items, :korea_price, :decimal, precision: 11, scale: 2
    change_column :sale_items, :unit_price, :decimal, precision: 11, scale: 2
    change_column :order_items, :unit_price, :decimal, precision: 11, scale: 2
  end
end
