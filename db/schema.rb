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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120814123421) do

  create_table "customers", :force => true do |t|
    t.string   "designation"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_name"
    t.string   "street_number"
    t.string   "zip_code"
    t.string   "city"
    t.string   "email"
    t.string   "childrens_class"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "status"
    t.float    "amount"
    t.string   "delivery_method"
    t.integer  "customer_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "prom_tables", :force => true do |t|
    t.integer  "position"
    t.string   "orientation"
    t.string   "caption"
    t.integer  "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "seats", :force => true do |t|
    t.integer  "prom_table_id"
    t.integer  "order_id"
    t.integer  "position"
    t.string   "caption"
    t.integer  "price"
    t.integer  "status"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
