# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_11_025115) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "approve_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "approvable_type"
    t.bigint "approvable_id"
    t.boolean "alive", default: true, null: false
    t.datetime "created_at", precision: 6, default: "2019-12-10 09:23:52", null: false
    t.datetime "updated_at", precision: 6, default: "2019-12-10 09:23:52", null: false
    t.index ["approvable_type", "approvable_id"], name: "index_approve_requests_on_approvable_type_and_approvable_id"
  end

  create_table "barcode_options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "barcode_id"
    t.bigint "product_option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barcode_id"], name: "index_barcode_options_on_barcode_id"
    t.index ["product_option_id"], name: "index_barcode_options_on_product_option_id"
  end

  create_table "barcodes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "cart_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.datetime "cancelled_at"
    t.index ["cart_item_id"], name: "index_barcodes_on_cart_item_id"
    t.index ["product_id"], name: "index_barcodes_on_product_id"
  end

  create_table "brands", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "company_id"
    t.string "name"
    t.string "eng_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "pixel_id"
    t.bigint "country_id"
    t.index ["company_id"], name: "index_brands_on_company_id"
    t.index ["country_id"], name: "index_brands_on_country_id"
  end

  create_table "cart_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "cart_id"
    t.integer "barcode_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id"
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "order_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.boolean "current", default: false, null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "countries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "name_ko"
    t.string "locale"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "file_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.integer "location", default: 0, null: false
    t.string "namespace", default: "", null: false
    t.string "original_filename"
    t.string "filename"
    t.string "filepath"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "manager_id", null: false
    t.integer "role", default: 0, null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_memberships_on_company_id"
    t.index ["manager_id"], name: "index_memberships_on_manager_id"
  end

  create_table "order_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "finished"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cart_id"
    t.string "enc_id"
    t.text "admin_memo"
    t.index ["enc_id"], name: "index_order_infos_on_enc_id", unique: true
  end

  create_table "pandals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_pandals_on_email", unique: true
    t.index ["reset_password_token"], name: "index_pandals_on_reset_password_token", unique: true
  end

  create_table "payments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "order_info_id"
    t.string "pay_method"
    t.boolean "paid"
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount"
    t.integer "total_price_sum"
    t.integer "total_discount_amount"
    t.integer "delivery_amount"
    t.datetime "expire_at"
    t.boolean "cancelled", default: false, null: false
    t.text "cancel_message"
    t.string "charge_id"
    t.index ["order_info_id"], name: "index_payments_on_order_info_id"
  end

  create_table "product_option_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id"
    t.string "name"
    t.boolean "is_required", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_option_groups_on_product_id"
  end

  create_table "product_options", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.integer "additional_price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_option_group_id"
    t.index ["product_option_group_id"], name: "index_product_options_on_product_option_group_id"
  end

  create_table "product_permits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "permitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_permits_on_product_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "brand_id"
    t.string "title"
    t.integer "price", default: 0, null: false
    t.integer "barcode_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "running_status", default: 0, null: false
    t.bigint "country_id"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["country_id"], name: "index_products_on_country_id"
  end

  create_table "ship_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "order_info_id"
    t.string "receiver_name"
    t.string "receiver_tel"
    t.string "receiver_email"
    t.string "loc_state"
    t.string "loc_city"
    t.string "loc_district"
    t.string "loc_detail"
    t.integer "ship_type", default: 0, null: false
    t.integer "ship_amount", default: 0, null: false
    t.string "user_memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "postal_code"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.string "profile_image"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
    t.boolean "is_manager"
    t.boolean "is_seller"
    t.string "invite_confirmation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "barcode_options", "barcodes"
  add_foreign_key "barcode_options", "product_options"
  add_foreign_key "barcodes", "cart_items"
  add_foreign_key "barcodes", "products"
  add_foreign_key "brands", "companies"
  add_foreign_key "brands", "countries"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "memberships", "companies"
  add_foreign_key "memberships", "users", column: "manager_id"
  add_foreign_key "payments", "order_infos"
  add_foreign_key "product_option_groups", "products"
  add_foreign_key "product_options", "product_option_groups"
  add_foreign_key "product_permits", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "countries"
end
