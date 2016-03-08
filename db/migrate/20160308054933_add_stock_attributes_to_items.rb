class AddStockAttributesToItems < ActiveRecord::Migration
  def change
    add_column :items, :t_shop, :integer
    add_column :items, :l_shop, :integer
    add_column :items, :l_store, :integer
  end
end
