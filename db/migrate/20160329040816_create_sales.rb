class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :customer_id
      t.integer :store_id
      t.text :remark

      t.timestamps null: false
    end
  end
end
