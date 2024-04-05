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

ActiveRecord::Schema[7.0].define(version: 2024_04_05_095123) do
  create_table "active_admin_comments", charset: "utf8mb4", force: :cascade do |t|
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

  create_table "admin_users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admin_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true
  end

  create_table "app_settings", charset: "utf8mb4", force: :cascade do |t|
    t.string "verify_token"
    t.string "secured_token"
    t.boolean "status", default: false
    t.string "openai_type"
    t.string "openai_uri"
    t.string "openai_model"
    t.string "openai_token"
    t.string "openai_api_version"
    t.string "instagram_permissions"
    t.string "facebook_permissions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auto_comments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.text "content"
    t.bigint "social_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["social_account_id"], name: "index_auto_comments_on_social_account_id"
  end

  create_table "blocked_commentators", charset: "utf8mb4", force: :cascade do |t|
    t.string "post_id"
    t.string "comment_id"
    t.string "commentator_id"
    t.bigint "social_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["social_account_id"], name: "index_blocked_commentators_on_social_account_id"
  end

  create_table "blockers", charset: "utf8mb4", force: :cascade do |t|
    t.string "post_id"
    t.string "comment_id"
    t.string "commentator_id"
    t.bigint "social_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["social_account_id"], name: "index_blockers_on_social_account_id"
  end

  create_table "orders", charset: "utf8mb4", force: :cascade do |t|
    t.integer "city_id"
    t.string "zip_code"
    t.string "delivery_address"
    t.boolean "status", default: false
    t.text "order_details", size: :long, collation: "utf8mb4_bin"
    t.bigint "user_id"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_payment_link_id"
    t.integer "product_quantity", default: 1
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.check_constraint "json_valid(`order_details`)", name: "order_details"
  end

  create_table "products", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "stripe_product_id"
    t.decimal "price", precision: 10, default: "0"
    t.boolean "status"
    t.text "product_details", size: :long, collation: "utf8mb4_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_price_id"
    t.check_constraint "json_valid(`product_details`)", name: "product_details"
  end

  create_table "seed_migration_data_migrations", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "version"
    t.integer "runtime"
    t.datetime "migrated_on", precision: nil
  end

  create_table "social_accounts", charset: "utf8mb4", force: :cascade do |t|
    t.string "verify_token"
    t.string "secured_token"
    t.boolean "status", default: false
    t.string "resource_id", null: false
    t.string "resource_name", null: false
    t.string "resource_platform", null: false
    t.string "resource_access_token"
    t.boolean "use_openai", default: false
    t.text "openai_prompt", default: "Please help me reply to this comment on Facebook, the comment content is \"#comment\". The commenter's name is \"#fullName\". Reply to them with appreciation, gratitude, or an empathetic comment. If someone says they miss someone, it's related to the content, not me. Comment length should not exceed 30 words. If the message is blank or you can't understand the context, give the person a cute song. Note: My Facebook page represents www.website.com, an online store dedicated to something..."
    t.integer "use_openai_when_comment_is_longer_in_length", default: 0
    t.integer "blocked_time", default: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_social_account_id"
    t.bigint "user_id"
    t.string "resource_username"
    t.index ["parent_social_account_id"], name: "index_social_accounts_on_parent_social_account_id"
    t.index ["user_id"], name: "index_social_accounts_on_user_id"
  end

  create_table "tokens", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "amount", default: 0
    t.text "token_details", size: :long, collation: "utf8mb4_bin"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
    t.check_constraint "json_valid(`token_details`)", name: "token_details"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.string "avatar"
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "blocked_commentators", "social_accounts"
  add_foreign_key "blockers", "social_accounts"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "tokens", "users"
end
