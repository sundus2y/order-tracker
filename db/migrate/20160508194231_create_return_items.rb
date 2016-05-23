class CreateReturnItems < ActiveRecord::Migration
  def change
    create_table :return_items do |t|
      t.integer :sale_item_id
      t.integer :qty
      t.text :note
      t.timestamps null: false
    end
  end
end
