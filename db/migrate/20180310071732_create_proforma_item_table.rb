class CreateProformaItemTable < ActiveRecord::Migration
  def change
    create_table :proforma_items do |t|
      t.integer  :proforma_id
      t.integer  :item_id
      t.integer  :qty, default: 0
      t.decimal  :unit_price, precision: 11, scale: 2, default: 0.0
      t.string   :status
      t.timestamps null: false
    end
  end
end
