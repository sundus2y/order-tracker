class AddSoldAtToSales < ActiveRecord::Migration
  def change
    add_column :sales, :sold_at, :datetime
  end
end
