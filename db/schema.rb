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

ActiveRecord::Schema.define(version: 20170724063819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_details", force: :cascade do |t|
    t.string   "api_version", null: false
    t.string   "app_version"
    t.string   "app_type"
    t.text     "faq"
    t.text     "about_us"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "message"
    t.boolean  "device_type"
  end

  create_table "booking_codes", force: :cascade do |t|
    t.string   "coupon_code"
    t.integer  "merchant_user_id"
    t.boolean  "redeemed",         default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "redeemed_at"
  end

  add_index "booking_codes", ["coupon_code"], name: "index_booking_codes_on_coupon_code", unique: true, using: :btree

  create_table "buyer_transaction_details", force: :cascade do |t|
    t.integer  "giveaway_id"
    t.integer  "end_user_id"
    t.string   "order_id"
    t.integer  "gateway_id"
    t.integer  "payment_status",                          default: 0
    t.decimal  "paid_amount",    precision: 10, scale: 2
    t.boolean  "refund"
    t.integer  "quantity"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "cashbacks", force: :cascade do |t|
    t.integer  "cashback_type",      default: 0
    t.string   "text"
    t.float    "discount"
    t.string   "code"
    t.boolean  "status",             default: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "deal_id"
    t.integer  "store_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "max_time_useable",   default: 1
    t.float    "points"
    t.datetime "publish_date"
    t.datetime "expiry_date"
    t.integer  "duration"
    t.text     "termsandconditions"
    t.boolean  "is_trending",        default: false
    t.integer  "trending_order"
    t.integer  "total_coupons"
    t.integer  "deal_category_id"
    t.boolean  "allow_com_deals",    default: false
  end

  create_table "category_versions", force: :cascade do |t|
    t.integer  "version",    default: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "icon_url"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "has_ad",        default: false
    t.boolean  "has_cashback",  default: false
    t.boolean  "has_lmd",       default: false
    t.boolean  "has_brands",    default: false
    t.boolean  "has_giveaways", default: true
  end

  create_table "cities_deal_categories", id: false, force: :cascade do |t|
    t.integer "city_id",          null: false
    t.integer "deal_category_id", null: false
  end

  add_index "cities_deal_categories", ["city_id", "deal_category_id"], name: "index_cities_deal_categories_on_city_id_and_deal_category_id", using: :btree
  add_index "cities_deal_categories", ["deal_category_id", "city_id"], name: "index_cities_deal_categories_on_deal_category_id_and_city_id", using: :btree

  create_table "club_membership_details", force: :cascade do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "server_url"
    t.string   "logo_url"
    t.string   "isd_code"
    t.boolean  "has_exclusive_club"
    t.boolean  "has_brands"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "has_cashback"
  end

  create_table "deal_analytics", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "user_id"
    t.integer  "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deal_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "sub_deal_category_id"
    t.integer  "deal_type",               default: 0
    t.string   "icon_url"
    t.integer  "priority_order"
    t.string   "logo_image_file_name"
    t.string   "logo_image_content_type"
    t.integer  "logo_image_file_size"
    t.datetime "logo_image_updated_at"
    t.string   "color_code"
  end

  add_index "deal_categories", ["sub_deal_category_id"], name: "index_deal_categories_on_sub_deal_category_id", using: :btree

  create_table "deal_categories_giveaways", id: false, force: :cascade do |t|
    t.integer "giveaway_id",      null: false
    t.integer "deal_category_id", null: false
  end

  create_table "deal_deal_categories", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "deal_category_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "deal_deal_categories", ["deal_category_id"], name: "index_deal_deal_categories_on_deal_category_id", using: :btree
  add_index "deal_deal_categories", ["deal_id", "deal_category_id"], name: "index_deal_deal_categories_on_deal_id_and_deal_category_id", using: :btree
  add_index "deal_deal_categories", ["deal_id"], name: "index_deal_deal_categories_on_deal_id", using: :btree

  create_table "deal_detail_images", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "deal_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "deal_outlets", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "outlet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "deal_outlets", ["deal_id"], name: "index_deal_outlets_on_deal_id", using: :btree
  add_index "deal_outlets", ["outlet_id", "deal_id"], name: "index_deal_outlets_on_outlet_id_and_deal_id", using: :btree
  add_index "deal_outlets", ["outlet_id"], name: "index_deal_outlets_on_outlet_id", using: :btree

  create_table "deals", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "deal_category_id"
    t.string   "main_line"
    t.text     "description"
    t.text     "notification_text"
    t.decimal  "notification_radius"
    t.string   "gender"
    t.boolean  "is_age_limit"
    t.integer  "age_from"
    t.integer  "age_to"
    t.boolean  "publish"
    t.datetime "publish_date"
    t.integer  "duration"
    t.string   "days"
    t.string   "coupon_image_content_type"
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.string   "featured_image_file_name"
    t.string   "featured_image_content_type"
    t.integer  "featured_image_file_size"
    t.datetime "featured_image_updated_at"
    t.datetime "created_at",                                                                           null: false
    t.datetime "updated_at",                                                                           null: false
    t.datetime "expiry_date"
    t.boolean  "status"
    t.text     "termsandconditions"
    t.text     "features"
    t.decimal  "price",                       precision: 10, scale: 2
    t.decimal  "discounted_price",            precision: 10, scale: 2
    t.integer  "last_coupons"
    t.time     "last_start_time"
    t.time     "last_end_time"
    t.time     "notification_time_from",                               default: '2000-01-01 00:00:00'
    t.time     "notification_time_to",                                 default: '2000-01-01 23:59:59'
    t.integer  "deal_type",                                            default: 0
    t.integer  "approved_by"
    t.integer  "max_bookings"
    t.integer  "max_quantity"
    t.integer  "quantity_per_user"
    t.decimal  "commission_percent"
    t.decimal  "tax_percent"
    t.float    "internet_handling_charges"
    t.boolean  "approx_date_flag",                                     default: false
    t.boolean  "is_sponsored",                                         default: false
    t.integer  "sponsor_order"
    t.integer  "valid_for"
    t.boolean  "display_timings",                                      default: false
    t.boolean  "appointment_mandatory",                                default: false
    t.boolean  "restrict_points",                                      default: false
  end

  add_index "deals", ["approved_by"], name: "index_deals_on_approved_by", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "end_user_applied_codes", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "cashback_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_user_bought_giveaways", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "giveaway_id"
    t.integer  "buyer_transaction_detail_id"
    t.integer  "giveaway_booking_code_id"
    t.boolean  "buyer_approved",              default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "end_user_categories", force: :cascade do |t|
    t.integer  "end_user_id",      null: false
    t.integer  "deal_category_id", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "end_user_categories", ["deal_category_id"], name: "index_end_user_categories_on_deal_category_id", using: :btree
  add_index "end_user_categories", ["end_user_id", "deal_category_id"], name: "index_end_user_categories_on_end_user_id_and_deal_category_id", unique: true, using: :btree
  add_index "end_user_categories", ["end_user_id"], name: "index_end_user_categories_on_end_user_id", using: :btree

  create_table "end_user_deal_notifications", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "deal_id"
    t.boolean  "aday",        default: true
    t.integer  "count",       default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "end_user_deal_reminders", force: :cascade do |t|
    t.integer  "end_user_id",                  null: false
    t.integer  "deal_id",                      null: false
    t.datetime "reminder_time"
    t.boolean  "status",        default: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "end_user_deal_reviews", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "deal_id",     null: false
    t.text     "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "rating"
  end

  create_table "end_user_favourite_stores", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "store_id",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "end_user_favourite_stores", ["end_user_id", "store_id"], name: "index_end_user_favourite_stores_on_end_user_id_and_store_id", unique: true, using: :btree
  add_index "end_user_favourite_stores", ["end_user_id"], name: "index_end_user_favourite_stores_on_end_user_id", using: :btree
  add_index "end_user_favourite_stores", ["store_id"], name: "index_end_user_favourite_stores_on_store_id", using: :btree

  create_table "end_user_favourites", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "deal_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "end_user_favourites", ["deal_id"], name: "index_end_user_favourites_on_deal_id", using: :btree
  add_index "end_user_favourites", ["end_user_id", "deal_id"], name: "index_end_user_favourites_on_end_user_id_and_deal_id", unique: true, using: :btree
  add_index "end_user_favourites", ["end_user_id"], name: "index_end_user_favourites_on_end_user_id", using: :btree

  create_table "end_user_feed_favourites", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "feed_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "end_user_feed_favourites", ["end_user_id", "feed_id"], name: "index_end_user_feed_favourites_on_end_user_id_and_feed_id", unique: true, using: :btree
  add_index "end_user_feed_favourites", ["end_user_id"], name: "index_end_user_feed_favourites_on_end_user_id", using: :btree
  add_index "end_user_feed_favourites", ["feed_id"], name: "index_end_user_feed_favourites_on_feed_id", using: :btree

  create_table "end_user_feed_reminders", force: :cascade do |t|
    t.integer  "end_user_id",                  null: false
    t.integer  "feed_id",                      null: false
    t.datetime "reminder_time"
    t.boolean  "status",        default: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "end_user_feed_reminders", ["end_user_id"], name: "index_end_user_feed_reminders_on_end_user_id", using: :btree
  add_index "end_user_feed_reminders", ["feed_id"], name: "index_end_user_feed_reminders_on_feed_id", using: :btree

  create_table "end_user_feed_reviews", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "feed_id",     null: false
    t.text     "message"
    t.integer  "rating"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "end_user_feed_reviews", ["end_user_id"], name: "index_end_user_feed_reviews_on_end_user_id", using: :btree
  add_index "end_user_feed_reviews", ["feed_id"], name: "index_end_user_feed_reviews_on_feed_id", using: :btree

  create_table "end_user_feedbacks", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.text     "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "contact"
  end

  create_table "end_user_follow_malls", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "mall_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "end_user_follow_malls", ["end_user_id", "mall_id"], name: "index_end_user_follow_malls_on_end_user_id_and_mall_id", unique: true, using: :btree
  add_index "end_user_follow_malls", ["end_user_id"], name: "index_end_user_follow_malls_on_end_user_id", using: :btree
  add_index "end_user_follow_malls", ["mall_id"], name: "index_end_user_follow_malls_on_mall_id", using: :btree

  create_table "end_user_follow_stores", force: :cascade do |t|
    t.integer  "end_user_id", null: false
    t.integer  "store_id",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "end_user_follow_stores", ["end_user_id", "store_id"], name: "index_end_user_follow_stores_on_end_user_id_and_store_id", unique: true, using: :btree
  add_index "end_user_follow_stores", ["end_user_id"], name: "index_end_user_follow_stores_on_end_user_id", using: :btree
  add_index "end_user_follow_stores", ["store_id"], name: "index_end_user_follow_stores_on_store_id", using: :btree

  create_table "end_user_giveaway_points", force: :cascade do |t|
    t.integer  "end_user_id"
    t.float    "points"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_user_points_histories", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "user_id"
    t.float    "points"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "cashback_id"
    t.integer  "deal_id"
    t.integer  "history_points_type", default: 0
    t.boolean  "points_status",       default: true
  end

  create_table "end_user_premium_notifications", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "premium_notification_id"
    t.boolean  "aday",                    default: true
    t.integer  "count",                   default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "end_user_reward_points", force: :cascade do |t|
    t.integer  "end_user_id"
    t.float    "points"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_user_sold_giveaways", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "giveaway_id"
    t.integer  "buyer_id"
    t.integer  "giveaway_booking_code_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "end_user_store_ref_codes", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "store_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_user_subscribed_cities", force: :cascade do |t|
    t.integer  "end_user_id"
    t.integer  "city_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "end_user_used_deals", force: :cascade do |t|
    t.integer  "end_user_id",                           null: false
    t.integer  "deal_id",                               null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "booking_code_id"
    t.boolean  "used_status",           default: false
    t.time     "time_slot_start_time"
    t.time     "time_slot_end_time"
    t.string   "phone_number"
    t.integer  "number_of_guests"
    t.date     "approx_arrival_date"
    t.integer  "transaction_detail_id"
    t.datetime "self_redeemed_at"
  end

  create_table "end_users", force: :cascade do |t|
    t.text     "name"
    t.string   "email"
    t.integer  "age"
    t.string   "gender"
    t.boolean  "device_type"
    t.text     "pn_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "password_digest",           default: "",    null: false
    t.boolean  "is_profile_update",         default: false
    t.boolean  "is_categories_set",         default: false
    t.integer  "login_type"
    t.text     "photo_url"
    t.string   "facebook_uid"
    t.string   "google_uid"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "otp_code"
    t.boolean  "otp_verified",              default: false
    t.boolean  "otp_requested",             default: false
    t.integer  "city_id"
    t.boolean  "notification_type",         default: false
    t.string   "phone_number"
    t.boolean  "phone_verified",            default: false
    t.integer  "club_membership_detail_id"
    t.integer  "voucher_code_detail_id"
    t.date     "membership_expiry_date"
    t.boolean  "transaction_updated",       default: false
    t.boolean  "black_listed",              default: false
  end

  create_table "feed_analytics", force: :cascade do |t|
    t.integer  "feed_id"
    t.integer  "user_id"
    t.integer  "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feed_analytics", ["feed_id"], name: "index_feed_analytics_on_feed_id", using: :btree
  add_index "feed_analytics", ["user_id", "feed_id", "flag"], name: "index_feed_analytics_on_user_id_and_feed_id_and_flag", unique: true, using: :btree
  add_index "feed_analytics", ["user_id"], name: "index_feed_analytics_on_user_id", using: :btree

  create_table "feed_detail_images", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "feed_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "feed_outlets", force: :cascade do |t|
    t.integer  "feed_id"
    t.integer  "outlet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "feed_outlets", ["feed_id"], name: "index_feed_outlets_on_feed_id", using: :btree
  add_index "feed_outlets", ["outlet_id", "feed_id"], name: "index_feed_outlets_on_outlet_id_and_feed_id", using: :btree
  add_index "feed_outlets", ["outlet_id"], name: "index_feed_outlets_on_outlet_id", using: :btree

  create_table "feeds", force: :cascade do |t|
    t.boolean  "status",             default: true
    t.integer  "store_id",                          null: false
    t.integer  "valid_at",           default: 0
    t.integer  "feed_type",          default: 0
    t.string   "title"
    t.text     "description"
    t.text     "termsandconditions"
    t.text     "features"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "publish"
    t.datetime "publish_date"
    t.integer  "duration"
    t.datetime "expiry_date"
    t.integer  "deal_id"
    t.integer  "deal_type",          default: 0
    t.float    "percent_value",      default: 0.0
    t.float    "amount_value",       default: 0.0
    t.integer  "buy_value",          default: 0
    t.integer  "get_value",          default: 0
    t.integer  "total_available",    default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "days"
  end

  create_table "firebase_push_notifications", force: :cascade do |t|
    t.string   "sendible_type"
    t.boolean  "sent",               default: false
    t.text     "results"
    t.text     "not_registered_ids"
    t.text     "data"
    t.integer  "success"
    t.integer  "failure"
    t.integer  "end_user_id"
    t.integer  "sendible_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "geo_coordinates", force: :cascade do |t|
    t.integer  "locationable_id"
    t.string   "locationable_type"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "geo_coordinates", ["locationable_type", "locationable_id"], name: "index_geo_coordinates_on_locationable_type_and_locationable_id", using: :btree

  create_table "giveaway_booking_codes", force: :cascade do |t|
    t.boolean  "buyer_approved"
    t.boolean  "seller_approved"
    t.string   "giveaway_code"
    t.integer  "seller_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "giveaways", force: :cascade do |t|
    t.string   "title"
    t.string   "venue"
    t.string   "locality"
    t.text     "price_url_proof"
    t.text     "tickets_delivery"
    t.text     "categorized_options"
    t.integer  "available_quantity"
    t.integer  "sold_type"
    t.integer  "quantity_type",                                           default: 0
    t.integer  "end_user_id"
    t.decimal  "min_bid_price",                  precision: 10, scale: 2
    t.decimal  "max_bid_price",                  precision: 10, scale: 2
    t.decimal  "instant_buyout_price",           precision: 10, scale: 2
    t.decimal  "actual_price",                   precision: 10, scale: 2
    t.date     "date"
    t.datetime "inst_giveaway_ends_in"
    t.datetime "bid_ends_in"
    t.boolean  "approved",                                                default: false
    t.boolean  "allow_bidding",                                           default: false
    t.boolean  "instant_approval",                                        default: false
    t.string   "ticket_proof_file_name"
    t.string   "ticket_proof_content_type"
    t.integer  "ticket_proof_file_size"
    t.datetime "ticket_proof_updated_at"
    t.string   "price_image_proof_file_name"
    t.string   "price_image_proof_content_type"
    t.integer  "price_image_proof_file_size"
    t.datetime "price_image_proof_updated_at"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.integer  "city_id"
    t.boolean  "sold_out",                                                default: false
  end

  create_table "malls", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "city"
    t.decimal  "xlatitude"
    t.decimal  "xlongitude"
    t.decimal  "radius",            default: 0.0
    t.text     "address"
    t.string   "contact_phone"
    t.string   "contact_persone"
    t.boolean  "status"
    t.string   "location"
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "expiry_date"
    t.integer  "duration"
    t.integer  "store_quota",       default: 0
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "city_id"
  end

  create_table "membership_transaction_details", force: :cascade do |t|
    t.integer  "club_membership_detail_id"
    t.integer  "end_user_id"
    t.integer  "payment_status",            default: 0
    t.string   "payu_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "merchant_users", force: :cascade do |t|
    t.string   "identifier",                                   null: false
    t.string   "password"
    t.string   "name"
    t.boolean  "status",                       default: true
    t.integer  "merchantable_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "is_lmd_live_without_approval", default: false
    t.boolean  "is_rd_live_without_approval",  default: false
    t.boolean  "is_ed_live_without_approval",  default: false
    t.string   "merchantable_type"
    t.boolean  "has_booking_codes",            default: false
  end

  add_index "merchant_users", ["merchantable_id", "merchantable_type"], name: "index_merchant_users_on_merchantable_id_and_merchantable_type", using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_token_deal_notifications", force: :cascade do |t|
    t.integer  "oauth_access_token_id",             null: false
    t.integer  "deal_id",                           null: false
    t.integer  "count",                 default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "oauth_access_token_deal_notifications", ["deal_id"], name: "index_on_deal_id", using: :btree
  add_index "oauth_access_token_deal_notifications", ["oauth_access_token_id", "deal_id"], name: "index_on_oauth_access_token_id_and_deal_id", unique: true, using: :btree
  add_index "oauth_access_token_deal_notifications", ["oauth_access_token_id"], name: "index_on_oauth_access_token_id", using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                              null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                         null: false
    t.string   "scopes"
    t.integer  "login_type"
    t.boolean  "device_type"
    t.text     "pn_id"
    t.string   "resource_owner_type"
    t.boolean  "notification_status", default: true
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "outlets", force: :cascade do |t|
    t.integer  "store_id"
    t.text     "address"
    t.string   "contact_phone"
    t.string   "contact_person"
    t.boolean  "status"
    t.string   "location"
    t.decimal  "xlatitude"
    t.decimal  "xlongitude"
    t.decimal  "radius"
    t.string   "locality"
    t.integer  "duration"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "phone_number"
  end

  create_table "payment_options", force: :cascade do |t|
    t.string   "name"
    t.boolean  "status",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "premium_notification_analytics", force: :cascade do |t|
    t.integer  "premium_notification_id"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "premium_notifications", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "deal_category_id"
    t.text     "notification_text"
    t.decimal  "radius",                 default: 0.0
    t.decimal  "xlatitude"
    t.decimal  "xlongitude"
    t.boolean  "publish"
    t.datetime "publish_date"
    t.integer  "duration"
    t.string   "days"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.datetime "expiry_date"
    t.boolean  "status"
    t.time     "notification_time_from", default: '2000-01-01 00:00:00'
    t.time     "notification_time_to",   default: '2000-01-01 23:59:59'
  end

  create_table "quota", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "total"
    t.integer  "used"
    t.integer  "premium_notification_total"
    t.integer  "premium_notification_used"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "rails_push_notifications_apns_apps", force: :cascade do |t|
    t.text     "apns_dev_cert"
    t.text     "apns_prod_cert"
    t.boolean  "sandbox_mode"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "app_type",       default: "end_user"
  end

  create_table "rails_push_notifications_gcm_apps", force: :cascade do |t|
    t.string   "gcm_key"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "app_type",   default: "end_user"
  end

  create_table "rails_push_notifications_mpns_apps", force: :cascade do |t|
    t.text     "cert"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "app_type",   default: "end_user"
  end

  create_table "rails_push_notifications_notifications", force: :cascade do |t|
    t.text     "destinations"
    t.integer  "app_id"
    t.string   "app_type"
    t.text     "data"
    t.text     "results"
    t.integer  "success"
    t.integer  "failed"
    t.boolean  "sent",          default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "end_user_id"
    t.integer  "sendible_id"
    t.string   "sendible_type"
  end

  add_index "rails_push_notifications_notifications", ["app_id", "app_type", "sent"], name: "app_and_sent_index_on_rails_push_notifications", using: :btree

  create_table "requested_giveaway_notifications", force: :cascade do |t|
    t.integer  "end_user_id"
    t.string   "aasm_state"
    t.text     "message"
    t.integer  "approved_by"
    t.datetime "approved_at"
    t.integer  "rejected_by"
    t.datetime "rejected_at"
    t.text     "rejected_because_of"
    t.integer  "delivered_by"
    t.datetime "delivered_at"
    t.string   "target_to"
    t.string   "target_device"
    t.integer  "target_deal_category_id"
    t.integer  "giveaway_id"
    t.integer  "city_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "requested_giveaway_notifications", ["end_user_id"], name: "index_requested_giveaway_notifications_on_end_user_id", using: :btree

  create_table "requested_notifications", force: :cascade do |t|
    t.integer  "merchant_user_id"
    t.string   "aasm_state"
    t.text     "message"
    t.integer  "approved_by"
    t.datetime "approved_at"
    t.integer  "rejected_by"
    t.datetime "rejected_at"
    t.text     "rejected_because_of"
    t.integer  "delivered_by"
    t.datetime "delivered_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "notification_type"
    t.integer  "merchantable_id"
    t.string   "merchantable_type"
    t.integer  "deal_id"
    t.string   "target_to"
    t.string   "target_device"
    t.boolean  "target_is_age_limit",     default: false
    t.integer  "target_age_from"
    t.integer  "target_age_to"
    t.string   "target_gender"
    t.integer  "city_id"
    t.integer  "target_deal_category_id"
    t.float    "target_distance"
  end

  add_index "requested_notifications", ["approved_by"], name: "index_requested_notifications_on_approved_by", using: :btree
  add_index "requested_notifications", ["merchant_user_id"], name: "index_requested_notifications_on_merchant_user_id", using: :btree
  add_index "requested_notifications", ["merchantable_id", "merchantable_type"], name: "index_on_merchantable_id_and_merchantable_type", using: :btree
  add_index "requested_notifications", ["rejected_by"], name: "index_requested_notifications_on_rejected_by", using: :btree

  create_table "sales_user_store_photos", force: :cascade do |t|
    t.integer  "sales_user_store_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "sales_user_stores", force: :cascade do |t|
    t.integer  "sales_user_id"
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "cover_pic_file_name"
    t.string   "cover_pic_content_type"
    t.integer  "cover_pic_file_size"
    t.datetime "cover_pic_updated_at"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "address_line_one"
    t.string   "address_line_two"
    t.string   "phone_number"
    t.string   "mgr_name"
    t.string   "email"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "working_days"
    t.boolean  "status",                 default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "creatable_id"
    t.string   "creatable_type"
    t.string   "owner_name"
    t.string   "owner_contact_number"
    t.string   "mgr_contact_number"
    t.integer  "city_id"
  end

  add_index "sales_user_stores", ["creatable_type", "creatable_id"], name: "index_sales_user_stores_on_creatable_type_and_creatable_id", using: :btree

  create_table "sales_users", force: :cascade do |t|
    t.string   "identifier",                   null: false
    t.string   "password"
    t.string   "name"
    t.string   "contact_phone"
    t.boolean  "status",        default: true
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "seller_transaction_details", force: :cascade do |t|
    t.integer  "giveaway_id"
    t.integer  "end_user_id"
    t.string   "order_id"
    t.integer  "gateway_id"
    t.integer  "payment_status",                          default: 0
    t.decimal  "paid_amount",    precision: 10, scale: 2
    t.boolean  "refund"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "store_categories", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "city"
    t.decimal  "xlatitude"
    t.decimal  "xlongitude"
    t.decimal  "radius",                         default: 0.0
    t.text     "address"
    t.string   "contact_phone"
    t.string   "contact_persone"
    t.boolean  "status"
    t.string   "location"
    t.integer  "store_category_id"
    t.integer  "user_id"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "expiry_date"
    t.integer  "duration"
    t.integer  "manageable_id"
    t.string   "manageable_type"
    t.string   "referral_code"
    t.string   "locality"
    t.time     "start_time",                     default: '2000-01-01 00:00:00'
    t.time     "end_time",                       default: '2000-01-01 23:59:59'
    t.integer  "city_id"
    t.decimal  "lmd_commission_percent",         default: 10.0
    t.string   "lmd_default_image_file_name"
    t.string   "lmd_default_image_content_type"
    t.integer  "lmd_default_image_file_size"
    t.datetime "lmd_default_image_updated_at"
    t.boolean  "is_brand_store",                 default: false
  end

  add_index "stores", ["referral_code"], name: "index_stores_on_referral_code", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "transaction_details", force: :cascade do |t|
    t.string   "bank_ref_id"
    t.text     "product_info"
    t.string   "payu_id"
    t.string   "payu_hash"
    t.integer  "payment_status",                                      default: 0
    t.integer  "settlement_status",                                   default: 0
    t.date     "settlement_date"
    t.integer  "quantity"
    t.decimal  "total_amount",               precision: 10, scale: 2
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.boolean  "refund",                                              default: false
    t.integer  "cashback_id"
    t.float    "points"
    t.integer  "end_user_applied_code_id"
    t.integer  "end_user_points_history_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "username"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "voucher_code_details", force: :cascade do |t|
    t.string   "code"
    t.integer  "club_membership_detail_id"
    t.boolean  "status",                    default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "voucher_code_details", ["club_membership_detail_id"], name: "index_voucher_code_details_on_club_membership_detail_id", using: :btree

  create_table "withdrawal_requests", force: :cascade do |t|
    t.float    "amount"
    t.string   "account_name"
    t.string   "ifsc_code"
    t.string   "order_id"
    t.string   "reason_for_rejection"
    t.integer  "account_number",       limit: 8
    t.integer  "transfer_type"
    t.integer  "status",                         default: 0
    t.integer  "end_user_id"
    t.date     "transfer_date"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_foreign_key "voucher_code_details", "club_membership_details"
end
