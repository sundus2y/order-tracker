class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :quantity
      t.string :unit
      t.float :unit_price

      t.timestamps null: false
    end
  end
end
