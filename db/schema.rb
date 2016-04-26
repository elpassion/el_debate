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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160426100014) do

  create_table "answers", force: :cascade do |t|
    t.integer "debate_id"
    t.string  "value"
    t.integer "answer_type"
  end

  add_index "answers", ["debate_id"], name: "index_answers_on_debate_id"

  create_table "auth_tokens", force: :cascade do |t|
    t.integer "debate_id"
    t.string  "value"
  end

  add_index "auth_tokens", ["debate_id"], name: "index_auth_tokens_on_debate_id"

  create_table "debates", force: :cascade do |t|
    t.string   "topic"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer "answer_id"
    t.integer "auth_token_id"
  end

  add_index "votes", ["answer_id"], name: "index_votes_on_answer_id"
  add_index "votes", ["auth_token_id"], name: "index_votes_on_auth_token_id"

end
