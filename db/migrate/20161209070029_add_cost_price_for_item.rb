class AddCostPriceForItem < ActiveRecord::Migration
  def change
    add_column :items, :cost_price, :decimal, precision: 11, scale: 2
  end
end
