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

ActiveRecord::Schema.define(version: 2018_04_25_191037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_source_member_maps", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "contact_source_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_source_id"], name: "index_contact_source_member_maps_on_contact_source_id"
    t.index ["member_id"], name: "index_contact_source_member_maps_on_member_id"
  end

  create_table "contact_sources", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_member_maps", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_member_maps_on_group_id"
    t.index ["member_id"], name: "index_group_member_maps_on_member_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logins", force: :cascade do |t|
    t.string "identification", null: false
    t.string "password_digest"
    t.string "oauth2_token", null: false
    t.string "uid"
    t.string "single_use_oauth2_token"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.index ["user_id"], name: "index_logins_on_user_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.integer "age", null: false
    t.string "place", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_url"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "contact_source_member_maps", "contact_sources"
  add_foreign_key "contact_source_member_maps", "members"
  add_foreign_key "group_member_maps", "groups"
  add_foreign_key "group_member_maps", "members"
end
