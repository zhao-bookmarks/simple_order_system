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

ActiveRecord::Schema.define(version: 20141031064750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "unit_id"
    t.decimal  "product_count",  default: 0.0
    t.date     "delivery_start"
    t.date     "delivery_end"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.integer  "type_id"
    t.integer  "target_id"
    t.text     "content"
    t.boolean  "is_read",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "number"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id",         default: 0
    t.integer  "element_status_id", default: 0
    t.integer  "send_status_id",    default: 0
    t.boolean  "is_ready",          default: false
  end

  create_table "products", force: true do |t|
    t.string   "number"
    t.string   "name"
    t.boolean  "is_minimum",      default: false
    t.boolean  "is_last",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "store",           default: 0.0
    t.boolean  "is_core",         default: false
    t.decimal  "alert_count",     default: 0.0
    t.string   "photo"
    t.boolean  "is_low",          default: false
    t.boolean  "is_out_of_stock", default: false
  end

  create_table "purchase_records", force: true do |t|
    t.integer  "purchase_id"
    t.integer  "product_id"
    t.integer  "unit_id"
    t.decimal  "product_count", default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchases", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ration_records", force: true do |t|
    t.integer  "ration_id"
    t.integer  "product_id"
    t.integer  "unit_id"
    t.decimal  "product_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rations", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipment_records", force: true do |t|
    t.integer  "shipment_id"
    t.integer  "product_id"
    t.integer  "unit_id"
    t.decimal  "product_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipments", force: true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_products", force: true do |t|
    t.integer  "parent_id"
    t.integer  "product_id"
    t.integer  "unit_id"
    t.decimal  "product_count", default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", force: true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.boolean  "is_default", default: false
    t.boolean  "is_base",    default: false
    t.decimal  "rate",       default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.string   "name"
  end

  create_table "warehouse_records", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.decimal  "old_store"
    t.decimal  "new_store"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "remark"
  end

end
