class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :title
      t.text :notes
      t.integer :created_by
      t.string :order_type
      t.timestamps null: false
    end
  end
end
