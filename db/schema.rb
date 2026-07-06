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

ActiveRecord::Schema[7.2].define(version: 2026_07_06_052502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.bigint "question_option_id"
    t.text "body"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "question_id"], name: "index_answers_on_user_id_and_question_id", unique: true
  end

  create_table "manual_ai_texts", force: :cascade do |t|
    t.bigint "manual_id", null: false
    t.integer "section_type", null: false
    t.text "ai_text", null: false
    t.text "user_edited_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manual_id", "section_type"], name: "index_manual_ai_texts_on_manual_id_and_section_type", unique: true
    t.index ["manual_id"], name: "index_manual_ai_texts_on_manual_id"
  end

  create_table "manuals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "theme", null: false
    t.string "share_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["share_token"], name: "index_manuals_on_share_token", unique: true
    t.index ["user_id", "theme"], name: "index_manuals_on_user_id_and_theme", unique: true
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.date "birthday", null: false
    t.integer "hometown", null: false
    t.integer "education", null: false
    t.integer "blood_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "question_options", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "label", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "theme", null: false
    t.string "title", null: false
    t.integer "answer_type", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "manual_ai_texts", "manuals"
  add_foreign_key "question_options", "questions"
end
