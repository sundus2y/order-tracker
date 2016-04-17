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

ActiveRecord::Schema.define(version: 20160416205912) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "item_number"
    t.datetime "created_at",      default: "now()", null: false
    t.datetime "updated_at",      default: "now()", null: false
    t.string   "original_number"
    t.string   "model"
    t.string   "car"
    t.string   "part_class"
    t.integer  "t_shop",          default: 0
    t.integer  "l_shop",          default: 0
    t.integer  "l_store",         default: 0
    t.date     "make_from"
    t.date     "make_to"
    t.string   "prev_number"
    t.string   "next_number"
    t.string   "brand"
    t.string   "made"
    t.float    "sale_price",      default: 0.0
    t.float    "dubai_price",     default: 0.0
    t.float    "korea_price",     default: 0.0
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "unit_price"
    t.integer  "brand"
    t.string   "status"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "title"
    t.text     "notes"
    t.integer  "created_by"
    t.string   "status"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "brand"
    t.integer  "order_items_count", default: 0
  end

  create_table "sale_items", force: :cascade do |t|
    t.integer  "sale_id"
    t.integer  "item_id"
    t.integer  "qty",        default: 0
    t.float    "unit_price", default: 0.0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "status"
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "store"
    t.text     "remark"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "status"
    t.integer  "sale_items_count", default: 0
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
