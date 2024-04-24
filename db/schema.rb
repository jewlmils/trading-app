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

ActiveRecord::Schema[7.1].define(version: 2024_04_20_064536) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "portfolio_stocks", force: :cascade do |t|
    t.bigint "portfolio_id", null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_portfolio_stocks_on_portfolio_id"
    t.index ["stock_id"], name: "index_portfolio_stocks_on_stock_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.bigint "trader_id", null: false
    t.bigint "stock_id", null: false
    t.integer "number_of_shares", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_portfolios_on_stock_id"
    t.index ["trader_id"], name: "index_portfolios_on_trader_id"
  end

  create_table "stock_prices", force: :cascade do |t|
    t.date "date"
    t.decimal "close_price"
    t.decimal "current_price"
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_prices_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker_symbol"
    t.string "company_name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticker_symbol"], name: "index_stocks_on_ticker_symbol", unique: true
  end

  create_table "traders", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.decimal "wallet", precision: 10, scale: 2, default: "0.0"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "approved", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin_created", default: false, null: false
    t.index ["approved"], name: "index_traders_on_approved"
    t.index ["confirmation_token"], name: "index_traders_on_confirmation_token", unique: true
    t.index ["email"], name: "index_traders_on_email", unique: true
    t.index ["reset_password_token"], name: "index_traders_on_reset_password_token", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "trader_id", null: false
    t.bigint "stock_id", null: false
    t.bigint "portfolio_id", null: false
    t.string "transaction_type"
    t.integer "number_of_shares"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_transactions_on_portfolio_id"
    t.index ["stock_id"], name: "index_transactions_on_stock_id"
    t.index ["trader_id"], name: "index_transactions_on_trader_id"
  end

  add_foreign_key "portfolio_stocks", "portfolios"
  add_foreign_key "portfolio_stocks", "stocks"
  add_foreign_key "portfolios", "stocks"
  add_foreign_key "portfolios", "traders"
  add_foreign_key "stock_prices", "stocks"
  add_foreign_key "transactions", "portfolios"
  add_foreign_key "transactions", "stocks"
  add_foreign_key "transactions", "traders"
end
