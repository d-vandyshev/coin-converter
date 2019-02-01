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

ActiveRecord::Schema.define(version: 2019_02_01_074243) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conversions", force: :cascade do |t|
    t.bigint "from_currency_id"
    t.bigint "to_currency_id"
    t.float "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_currency_id"], name: "index_conversions_on_from_currency_id"
    t.index ["to_currency_id"], name: "index_conversions_on_to_currency_id"
  end

  create_table "cryptocurrencies", force: :cascade do |t|
    t.string "name"
    t.string "symbol"
    t.float "price_usd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "conversions", "cryptocurrencies", column: "from_currency_id"
  add_foreign_key "conversions", "cryptocurrencies", column: "to_currency_id"
end
