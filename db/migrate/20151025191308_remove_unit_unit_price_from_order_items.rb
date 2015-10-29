class RemoveUnitUnitPriceFromOrderItems < ActiveRecord::Migration
  def change
    remove_column :order_items, :unit
  end
end
