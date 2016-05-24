class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :from_store
      t.integer :to_store
      t.text :note
      t.string :status
      t.integer :sale_items_count, default: 0

      t.timestamps null: false
    end
  end
end
