# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170225033754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.string   "phone"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "tin_no"
    t.integer  "category",   default: 0
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "item_id"
    t.integer  "qty"
    t.string   "location"
    t.datetime "created_at", default: "now()", null: false
    t.datetime "updated_at", default: "now()", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "item_number"
    t.datetime "created_at",                                  default: "now()", null: false
    t.datetime "updated_at",                                  default: "now()", null: false
    t.string   "original_number"
    t.string   "model"
    t.string   "car"
    t.string   "part_class"
    t.date     "make_from"
    t.date     "make_to"
    t.string   "prev_number"
    t.string   "next_number"
    t.string   "brand"
    t.string   "made"
    t.decimal  "sale_price",         precision: 11, scale: 2, default: 0.0
    t.decimal  "dubai_price",        precision: 11, scale: 2, default: 0.0
    t.decimal  "korea_price",        precision: 11, scale: 2, default: 0.0
    t.boolean  "default_sale_price"
    t.string   "size"
    t.decimal  "cost_price",         precision: 11, scale: 2
  end

  add_index "items", ["description"], name: "items_lower_description", using: :gin
  add_index "items", ["item_number"], name: "items_lower_item_number", using: :gin
  add_index "items", ["name"], name: "items_lower_name", using: :gin
  add_index "items", ["next_number"], name: "items_lower_next_number", using: :gin
  add_index "items", ["original_number"], name: "items_lower_original_number", using: :gin
  add_index "items", ["prev_number"], name: "items_lower_prev_number", using: :gin

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "unit_price", precision: 11, scale: 2
    t.string   "brand"
    t.string   "status"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "title"
    t.text     "notes"
    t.integer  "created_by"
    t.string   "status"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "brand"
    t.integer  "order_items_count", default: 0
  end

  create_table "return_items", force: :cascade do |t|
    t.integer  "sale_item_id"
    t.integer  "qty"
    t.text     "note"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer  "sale_id"
    t.integer  "item_id"
    t.integer  "qty",                                 default: 0
    t.decimal  "unit_price", precision: 11, scale: 2, default: 0.0
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "status"
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "store_id"
    t.text     "remark"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "status"
    t.integer  "sale_items_count", default: 0
    t.string   "transaction_num"
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "address"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "store_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tmp_item", id: false, force: :cascade do |t|
    t.string  "item_no", limit: 50,                          null: false
    t.string  "name",    limit: 50
    t.string  "a",       limit: 50
    t.string  "b",       limit: 50
    t.decimal "price",              precision: 11, scale: 2, null: false
  end

  create_table "transaction_num_counters", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transfer_items", force: :cascade do |t|
    t.integer  "transfer_id"
    t.integer  "item_id"
    t.integer  "qty"
    t.string   "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "location"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.integer  "from_store_id"
    t.integer  "to_store_id"
    t.text     "note"
    t.string   "status"
    t.integer  "transfer_items_count", default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.date     "sent_date"
    t.date     "received_date"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
