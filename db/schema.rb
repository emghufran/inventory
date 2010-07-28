# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100724130058) do

  create_table "bunkers", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_details", :force => true do |t|
    t.integer  "job_id"
    t.integer  "part_id"
    t.integer  "bunker_id"
    t.integer  "quantity"
    t.integer  "consumed"
    t.integer  "junk"
    t.integer  "sign_in"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "user_id"
    t.string   "engineer"
    t.string   "gun_shop_superviser"
    t.string   "truck"
    t.string   "rig"
    t.string   "well"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",              :limit => 40
    t.string   "attachment_path"
    t.string   "explosive_van",       :limit => 64
  end

  create_table "mail_managers", :force => true do |t|
    t.string   "email"
    t.string   "role",       :limit => 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movements", :force => true do |t|
    t.integer  "part_id"
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "quantity"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "movement_type"
  end

  create_table "orders", :force => true do |t|
    t.integer  "part_id"
    t.integer  "user_id"
    t.integer  "original_quantity"
    t.integer  "received_quantity"
    t.string   "order_number"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "part_number"
    t.string   "description"
    t.integer  "lawson_price",                 :limit => 10, :precision => 10, :scale => 0
    t.string   "box_size"
    t.integer  "un_num"
    t.string   "class_name"
    t.integer  "package_quantity"
    t.string   "package_type"
    t.integer  "gross_weight",                 :limit => 10, :precision => 10, :scale => 0
    t.integer  "net_weight",                   :limit => 10, :precision => 10, :scale => 0
    t.integer  "gm_box",                       :limit => 10, :precision => 10, :scale => 0
    t.integer  "gm_unit",                      :limit => 10, :precision => 10, :scale => 0
    t.string   "um"
    t.integer  "spf"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "ce_certificate"
    t.string   "transport_approval_document"
    t.string   "product_identification_sheet"
    t.string   "msds"
    t.string   "declaration_of_conformity"
  end

  create_table "update_inventories", :force => true do |t|
    t.integer  "part_id"
    t.integer  "bunker_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "is_approved",                              :default => 0
    t.string   "role",                                     :default => "Engineer"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
