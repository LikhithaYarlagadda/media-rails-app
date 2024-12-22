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

ActiveRecord::Schema[7.2].define(version: 2024_12_22_122335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_users", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "user_id", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_users_on_article_id"
    t.index ["user_id"], name: "index_article_users_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.string "media_url"
    t.bigint "approved_by_id"
    t.string "status", default: "Pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "section_id"
    t.bigint "primary_contributor_id"
    t.index ["approved_by_id"], name: "index_articles_on_approved_by_id"
    t.index ["primary_contributor_id"], name: "index_articles_on_primary_contributor_id"
    t.index ["section_id"], name: "index_articles_on_section_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.bigint "parent_comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["parent_comment_id"], name: "index_comments_on_parent_comment_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.string "reaction_type", null: false
    t.string "reactable_type", null: false
    t.bigint "reactable_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reactable_type", "reactable_id"], name: "index_reactions_on_reactable"
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name", null: false
    t.string "dimensions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "Viewer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "article_users", "articles"
  add_foreign_key "article_users", "users"
  add_foreign_key "articles", "sections"
  add_foreign_key "articles", "users", column: "approved_by_id"
  add_foreign_key "articles", "users", column: "primary_contributor_id"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "comments", column: "parent_comment_id"
  add_foreign_key "comments", "users"
  add_foreign_key "reactions", "users"
end
