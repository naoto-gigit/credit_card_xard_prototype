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

ActiveRecord::Schema[8.0].define(version: 2025_07_19_044742) do
  create_table "card_applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status"
    t.string "document_type"
    t.string "document_number"
    t.string "full_name"
    t.date "date_of_birth"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_name"
    t.string "employment_type"
    t.integer "years_of_service"
    t.integer "annual_income"
    t.integer "other_debt"
    t.integer "credit_limit"
    t.string "credit_decision"
    t.integer "credit_score"
    t.index ["user_id"], name: "index_card_applications_on_user_id"
  end

  create_table "cards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "xard_card_id"
    t.integer "user_id"
    t.string "last_4_digits"
    t.string "card_type"
    t.string "status"
    t.datetime "issued_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "statement_id", null: false
    t.integer "amount", default: 0, null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statement_id"], name: "index_payments_on_statement_id"
  end

  create_table "statements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "billing_period_start_date"
    t.date "billing_period_end_date"
    t.integer "amount", default: 0, null: false
    t.date "due_date"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_statements_on_status"
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.string "merchant_name"
    t.integer "amount"
    t.datetime "transacted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_transactions_on_card_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.text "address"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "card_applications", "users"
  add_foreign_key "payments", "statements"
  add_foreign_key "statements", "users"
  add_foreign_key "transactions", "cards"
end
