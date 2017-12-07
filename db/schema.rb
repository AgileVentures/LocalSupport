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

ActiveRecord::Schema.define(version: 20170816184646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "charity_commission_id"
    t.string "charity_commission_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories_organisations", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "organisation_id"
    t.index ["category_id"], name: "index_categories_organisations_on_category_id"
    t.index ["organisation_id"], name: "index_categories_organisations_on_organisation_id"
  end

  create_table "doit_traces", id: :serial, force: :cascade do |t|
    t.datetime "published_at"
    t.integer "volunteer_op_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "doit_volop_id"
    t.index ["doit_volop_id"], name: "index_doit_traces_on_doit_volop_id"
    t.index ["volunteer_op_id"], name: "index_doit_traces_on_volunteer_op_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "features", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: false
  end

  create_table "mail_templates", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "body"
    t.text "footnote"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisations", id: :serial, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "address", default: "", null: false
    t.string "postcode", default: "", null: false
    t.string "email", default: "", null: false
    t.text "description", default: "", null: false
    t.string "website", default: "", null: false
    t.string "telephone", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "latitude"
    t.float "longitude"
    t.boolean "gmaps"
    t.text "donation_info", default: "", null: false
    t.boolean "publish_address", default: false
    t.boolean "publish_phone", default: false
    t.boolean "publish_email", default: true
    t.datetime "deleted_at"
    t.string "type", default: "Organisation"
    t.boolean "non_profit"
    t.string "slug"
    t.index ["slug"], name: "index_organisations_on_slug", unique: true
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "permalink"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "link_visible", default: true
    t.index ["permalink"], name: "index_pages_on_permalink"
  end

  create_table "proposed_organisation_edits", id: :serial, force: :cascade do |t|
    t.integer "organisation_id"
    t.string "name", default: "", null: false
    t.string "address", default: "", null: false
    t.string "postcode", default: "", null: false
    t.string "email", default: "", null: false
    t.text "description", default: "", null: false
    t.string "website", default: "", null: false
    t.string "telephone", default: "", null: false
    t.text "donation_info", default: "", null: false
    t.datetime "deleted_at"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "accepted", default: false, null: false
    t.boolean "archived", default: false, null: false
    t.index ["deleted_at"], name: "index_proposed_organisation_edits_on_deleted_at"
    t.index ["user_id"], name: "index_proposed_organisation_edits_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "superadmin", default: false
    t.integer "organisation_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "pending_organisation_id"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.datetime "deleted_at"
    t.boolean "siteadmin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "volunteer_ops", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "organisation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "source", default: "local"
    t.string "doit_op_link"
    t.string "doit_op_id"
    t.string "doit_org_link"
    t.string "doit_org_name"
    t.float "longitude"
    t.float "latitude"
    t.datetime "deleted_at"
    t.string "address"
    t.string "postcode"
    t.string "reachskills_org_name"
    t.string "reachskills_op_link"
    t.index ["deleted_at"], name: "index_volunteer_ops_on_deleted_at"
    t.index ["organisation_id"], name: "index_volunteer_ops_on_organisation_id"
  end

  add_foreign_key "doit_traces", "volunteer_ops"
end
