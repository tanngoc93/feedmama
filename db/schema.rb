# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_04_065800) do
  create_table "active_admin_comments", charset: "utf8mb3", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "blockers", charset: "utf8mb3", force: :cascade do |t|
    t.string "post_id"
    t.string "commentator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "social_account_id"
  end

  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", charset: "utf8mb3", force: :cascade do |t|
    t.string "facebook_page_id"
    t.string "facebook_page_access_token"
    t.string "facebook_verify_token"
    t.string "kind_of_bot"
    t.string "bot_endpoint"
    t.string "bot_token"
    t.text "input"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_accounts", charset: "utf8mb3", force: :cascade do |t|
    t.string "resource_id", null: false
    t.string "resource_name", null: false
    t.string "resource_platform", null: false
    t.string "resource_access_token"
    t.text "search_terms"
    t.boolean "active", default: false
    t.string "verify_token"
    t.string "secured_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
