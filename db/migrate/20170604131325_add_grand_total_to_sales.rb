class AddGrandTotalToSales < ActiveRecord::Migration
  def change
    add_column :sales, :grand_total, :decimal, precision: 11, scale: 2
  end
end
