class CreateSaleItems < ActiveRecord::Migration
  def change
    create_table :sale_items do |t|
      t.integer :sale_id
      t.integer :item_id
      t.integer :qty
      t.integer :unit_price

      t.timestamps null: false
    end
  end
end
