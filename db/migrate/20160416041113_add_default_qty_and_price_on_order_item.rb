class AddDefaultQtyAndPriceOnOrderItem < ActiveRecord::Migration
  def change
    change_column_default :sale_items, :qty, 0
    change_column_default :sale_items, :unit_price, 0.0
  end
end
