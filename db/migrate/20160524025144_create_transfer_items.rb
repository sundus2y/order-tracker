class CreateTransferItems < ActiveRecord::Migration
  def change
    create_table :transfer_items do |t|
      t.integer :transfer_id
      t.integer :item_id
      t.integer :qty
      t.string :status

      t.timestamps null: false
    end
  end
end
