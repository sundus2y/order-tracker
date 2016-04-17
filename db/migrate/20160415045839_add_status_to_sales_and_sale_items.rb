class AddStatusToSalesAndSaleItems < ActiveRecord::Migration
  def change
    add_column :sales, :status, :string
    add_column :sale_items, :status, :string
  end
end
