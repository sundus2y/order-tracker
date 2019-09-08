class AddCopyTable < ActiveRecord::Migration[5.2]
  def change
    create_table :item_copies, :force => true do |t|
      t.string "name"
      t.text "description"
      t.string "item_number"
      t.datetime "created_at", default: -> { "now()" }, null: false
      t.datetime "updated_at", default: -> { "now()" }, null: false
      t.string "original_number"
      t.string "model"
      t.string "car"
      t.string "part_class"
      t.date "make_from"
      t.date "make_to"
      t.string "prev_number"
      t.string "next_number"
      t.string "brand"
      t.string "made"
      t.decimal "sale_price", precision: 11, scale: 2, default: "0.0"
      t.decimal "dubai_price", precision: 11, scale: 2, default: "0.0"
      t.decimal "korea_price", precision: 11, scale: 2, default: "0.0"
      t.boolean "default_sale_price"
      t.string "size"
      t.decimal "cost_price", precision: 11, scale: 2
      t.decimal "c_price", precision: 11, scale: 2
      t.datetime "deleted_at"
      t.decimal "hy_price", precision: 11, scale: 2
      t.decimal "kia_price", precision: 11, scale: 2
    end
  end
end
