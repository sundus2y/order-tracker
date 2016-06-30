class RemoveInventoryFieldsFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :t_shop
    remove_column :items, :l_shop
    remove_column :items, :l_store
  end
end
