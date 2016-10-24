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

ActiveRecord::Schema.define(version: 20161021084326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer "debate_id"
    t.string  "value"
    t.integer "answer_type"
    t.index ["debate_id"], name: "index_answers_on_debate_id", using: :btree
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.integer "debate_id"
    t.string  "value"
    t.index ["debate_id"], name: "index_auth_tokens_on_debate_id", using: :btree
    t.index ["value"], name: "index_auth_tokens_on_value", unique: true, using: :btree
  end

  create_table "debates", force: :cascade do |t|
    t.string   "topic"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "closed_at"
    t.index ["code"], name: "index_debates_on_code", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.integer "answer_id"
    t.integer "auth_token_id"
    t.index ["answer_id"], name: "index_votes_on_answer_id", using: :btree
    t.index ["auth_token_id"], name: "index_votes_on_auth_token_id", using: :btree
  end

end
