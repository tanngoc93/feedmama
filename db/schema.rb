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

ActiveRecord::Schema[7.0].define(version: 2023_05_12_102413) do
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

  create_table "app_settings", charset: "utf8mb3", force: :cascade do |t|
    t.boolean "status", default: false
    t.string "verify_token"
    t.string "secured_token"
    t.string "openai_token"
    t.string "openai_model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blockers", charset: "utf8mb3", force: :cascade do |t|
    t.string "post_id"
    t.string "comment_id"
    t.string "commentator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "social_account_id"
  end

  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.string "comment_id"
    t.string "comment"
    t.string "replied_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seed_migration_data_migrations", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "version"
    t.integer "runtime"
    t.datetime "migrated_on", precision: nil
  end

  create_table "social_accounts", charset: "utf8mb3", force: :cascade do |t|
    t.string "resource_id", null: false
    t.string "resource_name", null: false
    t.string "resource_platform", null: false
    t.string "resource_access_token"
    t.text "search_terms", default: "Please help me write a creative/engaging message to reply to a comment on my Facebook, the comment content is \"#comment\".\\r\\n\\r\\nThe commenter's name is \"#fullName\".\\r\\n\\r\\nDepending on the emotion of the comment, please help me reply to them with appreciation, gratitude, or an empathetic comment.\\r\\n\\r\\nBe kind, energetic, and full of love.\\r\\n\\r\\nAnd if possible choose an icon for the comment you make, it should match the emotion of the comment, for example, the comment's emotion is positive, happy should not choose the sad symbol, and vice versa.\\r\\n\\r\\nMake it 10 to 30 words long.\\r\\n\\r\\nIf the message is blank or you can't understand the context, give the person a cute song.\\r\\n\\r\\nNote: My Facebook page represents Someone/Something, an online store dedicated to custom jewelry as gifts for various occasions and for a wide audience, mainly between family members and their friends."
    t.boolean "status", default: false
    t.string "verify_token"
    t.string "secured_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "use_openai", default: false
    t.text "basic_comment", default: ""
    t.integer "comment_length", default: 0
  end

end
