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

ActiveRecord::Schema.define(:version => 20141024215924) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "charity_commission_id"
    t.string   "charity_commission_name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "categories_organisations", :force => true do |t|
    t.integer "category_id"
    t.integer "organisation_id"
  end

  create_table "features", :force => true do |t|
    t.string  "name"
    t.boolean "active", :default => false
  end

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "postcode"
    t.string   "email"
    t.text     "description"
    t.string   "website"
    t.string   "telephone"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.text     "donation_info"
    t.boolean  "publish_address", :default => false
    t.boolean  "publish_phone",   :default => false
    t.boolean  "publish_email",   :default => true
    t.datetime "deleted_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "link_visible", :default => true
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"

  create_table "users", :force => true do |t|
    t.string   "email",                   :default => "",    :null => false
    t.string   "encrypted_password",      :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "admin",                   :default => false
    t.integer  "organisation_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "pending_organisation_id"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "volunteer_ops", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "organisation_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "volunteer_ops", ["organisation_id"], :name => "index_volunteer_ops_on_organisation_id"

end
