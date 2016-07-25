class CreateTransactionNumCounter < ActiveRecord::Migration
  def change
    create_table :transaction_num_counters do |t|
      t.integer :store_id
      t.integer :counter

      t.timestamps null: false
    end
  end
end
