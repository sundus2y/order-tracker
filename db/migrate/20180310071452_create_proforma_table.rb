class CreateProformaTable < ActiveRecord::Migration
  def change
    create_table :proformas do |t|
      t.integer  :customer_id
      t.integer  :store_id
      t.text     :remark
      t.string   :status
      t.integer  :proforma_items_count, default: 0
      t.string   :transaction_num
      t.integer  :creator_id
      t.decimal  :grand_total, precision: 11, scale: 2
      t.timestamps null: false
    end
  end
end
