class UpdateQtyDefaultOnItem < ActiveRecord::Migration
  def change
    change_column :items, :l_shop, :integer, default: 0
    change_column :items, :t_shop, :integer, default: 0
    change_column :items, :l_store, :integer, default: 0
  end
end
