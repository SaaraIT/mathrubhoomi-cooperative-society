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

ActiveRecord::Schema[8.0].define(version: 2025_03_02_080451) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cooperative_banks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cooperative_branches", force: :cascade do |t|
    t.string "name"
    t.integer "cooperative_bank_id"
    t.string "english_address"
    t.string "kannada_address"
    t.string "r_no"
    t.string "phone_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.string "name"
    t.string "father_or_husband_name"
    t.string "mobile_number"
    t.string "aadhaar_number"
    t.string "voter_id"
    t.string "pan_card"
    t.string "driving_license"
    t.integer "age"
    t.string "education"
    t.string "occupation"
    t.text "permanent_address"
    t.text "present_address"
    t.string "religion"
    t.string "caste_category"
    t.integer "number_of_shares"
    t.decimal "amount", precision: 10, scale: 2
    t.string "nominee_name"
    t.text "nominee_address"
    t.string "nominee_relationship"
    t.string "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "other_particulars"
    t.string "place"
    t.date "date"
    t.date "signed_date"
    t.string "signature"
    t.string "nominee_phone"
    t.string "address_a_building"
    t.string "address_a_village"
    t.string "address_a_district"
    t.string "address_a_pincode"
    t.string "address_b_building"
    t.string "address_b_village"
    t.string "address_b_district"
    t.string "address_b_pincode"
    t.string "md_sign_place"
    t.date "md_signed_date"
    t.string "resolution_no"
    t.date "resolution_date"
    t.string "member_no"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "role"
    t.integer "cooperative_branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
