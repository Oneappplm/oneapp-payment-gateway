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

ActiveRecord::Schema[7.1].define(version: 2025_06_19_174456) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointments", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.datetime "appointment_date"
    t.string "reason"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_appointments_on_doctor_id"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "specialty"
    t.string "license_number"
    t.string "email"
    t.string "phone"
    t.string "clinic_name"
    t.string "clinic_address"
    t.string "location"
    t.boolean "email_verified"
    t.boolean "phone_verified"
    t.boolean "license_verified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.bigint "patient_id", null: false
    t.bigint "appointment_id", null: false
    t.string "service_name"
    t.decimal "amount"
    t.decimal "discount"
    t.decimal "total"
    t.string "qr_code_url"
    t.string "payment_memo"
    t.string "payment_method"
    t.string "solana_signature"
    t.string "status", default: "unpaid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice_number"
    t.string "clinic_name"
    t.date "date_of_service"
    t.text "service_description"
    t.decimal "tax", precision: 10, scale: 2
    t.decimal "medv_token_amount", precision: 10, scale: 2
    t.date "due_date"
    t.boolean "payment_confirmation_status", default: false
    t.integer "crypto_type"
    t.integer "blockchain_network"
    t.decimal "conversion_rate"
    t.string "sender_wallet_address"
    t.string "receiver_wallet_address"
    t.datetime "payment_timestamp"
    t.decimal "transaction_fee"
    t.integer "discount_type"
    t.date "discount_start_date"
    t.date "discount_end_date"
    t.index ["appointment_id"], name: "index_invoices_on_appointment_id"
    t.index ["doctor_id"], name: "index_invoices_on_doctor_id"
    t.index ["patient_id"], name: "index_invoices_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.bigint "doctor_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.text "medical_history"
    t.string "emergency_contact"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.string "email_address"
    t.string "phone_number"
    t.text "current_medications"
    t.string "insurance_information"
    t.text "allergies"
    t.string "address"
    t.date "next_appointment"
    t.date "last_visit_date"
    t.boolean "active"
    t.index ["doctor_id"], name: "index_patients_on_doctor_id"
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "appointments", "doctors"
  add_foreign_key "appointments", "patients"
  add_foreign_key "invoices", "appointments"
  add_foreign_key "invoices", "doctors"
  add_foreign_key "invoices", "patients"
  add_foreign_key "patients", "doctors"
end
