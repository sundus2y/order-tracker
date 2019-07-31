# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_30_223248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "cars", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.string "vin_no"
    t.string "plate_no"
    t.string "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "brand"
    t.string "model"
    t.string "owner"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cars_on_deleted_at"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "company"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tin_no"
    t.integer "category", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_customers_on_deleted_at"
  end

  create_table "impressions", id: :serial, force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "inventories", id: :serial, force: :cascade do |t|
    t.integer "store_id"
    t.integer "item_id"
    t.integer "qty"
    t.string "location"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_inventories_on_deleted_at"
  end

  create_table "items", id: :serial, force: :cascade do |t|
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
    t.index ["deleted_at"], name: "index_items_on_deleted_at"
    t.index ["description"], name: "items_lower_description", opclass: :gin_trgm_ops, using: :gin
    t.index ["item_number"], name: "items_lower_item_number", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "items_lower_name", opclass: :gin_trgm_ops, using: :gin
    t.index ["next_number"], name: "items_lower_next_number", opclass: :gin_trgm_ops, using: :gin
    t.index ["original_number"], name: "items_lower_original_number", opclass: :gin_trgm_ops, using: :gin
    t.index ["prev_number"], name: "items_lower_prev_number", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.integer "item_id"
    t.integer "qty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "unit_price", precision: 11, scale: 2
    t.string "brand"
    t.string "status"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_order_items_on_deleted_at"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "notes"
    t.integer "creator_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "brand"
    t.integer "order_items_count", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
  end

  create_table "proforma_items", id: :serial, force: :cascade do |t|
    t.integer "proforma_id"
    t.integer "item_id"
    t.integer "qty", default: 0
    t.decimal "unit_price", precision: 11, scale: 2, default: "0.0"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remark"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_proforma_items_on_deleted_at"
  end

  create_table "proformas", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "store_id"
    t.text "remark"
    t.string "status"
    t.integer "proforma_items_count", default: 0
    t.string "transaction_num"
    t.integer "creator_id"
    t.decimal "grand_total", precision: 11, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sold_at"
    t.integer "car_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_proformas_on_deleted_at"
  end

  create_table "return_items", id: :serial, force: :cascade do |t|
    t.integer "sale_item_id"
    t.integer "qty"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_return_items_on_deleted_at"
  end

  create_table "sale_items", id: :serial, force: :cascade do |t|
    t.integer "sale_id"
    t.integer "item_id"
    t.integer "qty", default: 0
    t.decimal "unit_price", precision: 11, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sale_items_on_deleted_at"
  end

  create_table "sales", id: :serial, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "store_id"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.integer "sale_items_count", default: 0
    t.string "transaction_num"
    t.integer "creator_id"
    t.decimal "grand_total", precision: 11, scale: 2
    t.string "fs_num"
    t.datetime "sold_at"
    t.integer "proforma_id"
    t.integer "car_id"
    t.datetime "delivery_date"
    t.decimal "down_payment", precision: 11, scale: 2
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sales_on_deleted_at"
  end

  create_table "search_items", id: :serial, force: :cascade do |t|
    t.string "item_number"
    t.string "original_number"
    t.string "made"
    t.string "brand"
  end

  create_table "stores", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "address"
    t.string "phone1"
    t.string "phone2"
    t.string "store_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_stores_on_deleted_at"
  end

  create_table "tmp_item", id: false, force: :cascade do |t|
    t.string "item_no", limit: 50, null: false
    t.decimal "price", precision: 11, scale: 2, null: false
  end

  create_table "transaction_num_counters", id: :serial, force: :cascade do |t|
    t.integer "store_id"
    t.integer "counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "klass_name"
  end

  create_table "transfer_items", id: :serial, force: :cascade do |t|
    t.integer "transfer_id"
    t.integer "item_id"
    t.integer "qty"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.datetime "deleted_at"
    t.integer "inventory_after"
    t.index ["deleted_at"], name: "index_transfer_items_on_deleted_at"
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "from_store_id"
    t.integer "to_store_id"
    t.text "note"
    t.string "status"
    t.integer "transfer_items_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sent_date"
    t.datetime "received_date"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_transfers_on_deleted_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.integer "role"
    t.integer "default_store_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
