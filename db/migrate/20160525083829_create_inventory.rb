class CreateInventory < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :store_id
      t.integer :item_id
      t.integer :qty
      t.integer :location

      t.timestamps null: false
    end
  end
end
