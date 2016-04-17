class AddSaleItemsCountToSales < ActiveRecord::Migration
  def up
    add_column :sales, :sale_items_count, :integer, :default => 0

    Sale.reset_column_information
    Sale.all.each do |o|
      o.update_attribute :sale_items_count, o.sale_items.count
    end
  end

  def down
    remove_column :Sales, :sale_items_count
  end
end
