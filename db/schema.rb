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

ActiveRecord::Schema.define(:version => 20130811193914) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "contacts", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "photo"
  end

  create_table "photos", :force => true do |t|
    t.string   "type"
    t.string   "attachment"
    t.integer  "yacht_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "photos", ["type"], :name => "index_photos_on_type"

  create_table "yachts", :force => true do |t|
    t.string   "name",           :default => "",    :null => false
    t.integer  "year",           :default => 2013
    t.float    "length",         :default => 0.0
    t.float    "width",          :default => 0.0
    t.float    "weight",         :default => 0.0
    t.float    "draft",          :default => 0.0
    t.integer  "fuel_tank",      :default => 0
    t.integer  "water_tank",     :default => 0
    t.string   "engine",         :default => ""
    t.integer  "engines_count",  :default => 0
    t.float    "capacity",       :default => 0.0
    t.integer  "speed",          :default => 0
    t.integer  "hours",          :default => 0
    t.string   "location",       :default => ""
    t.string   "color",          :default => ""
    t.text     "description",    :default => "",    :null => false
    t.boolean  "customs",        :default => false
    t.integer  "price",          :default => 0,     :null => false
    t.string   "currency",       :default => "EUR", :null => false
    t.text     "equipment",      :default => ""
    t.text     "spare_parts",    :default => ""
    t.text     "comments",       :default => ""
    t.text     "options",        :default => ""
    t.text     "interiors",      :default => ""
    t.string   "status"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "cabins",         :default => ""
    t.string   "bunks",          :default => ""
    t.integer  "cruising_speed", :default => 0
  end

  add_index "yachts", ["status"], :name => "index_yachts_on_status"

end
