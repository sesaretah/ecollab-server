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

ActiveRecord::Schema.define(version: 2021_09_06_075514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "create_event"
    t.boolean "create_exhibition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "modify_ability"
    t.boolean "administration"
    t.index ["user_id"], name: "index_abilities_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.string "content"
    t.integer "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answers_on_answer_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "user_id"
    t.integer "attendable_id"
    t.string "attendable_type"
    t.integer "label_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.string "duty"
    t.index ["attendable_id"], name: "index_attendances_on_attendable_id"
    t.index ["attendable_type"], name: "index_attendances_on_attendable_type"
    t.index ["duty"], name: "index_attendances_on_duty"
    t.index ["label_id"], name: "index_attendances_on_label_id"
    t.index ["role_id"], name: "index_attendances_on_role_id"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.integer "user_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "discussions", force: :cascade do |t|
    t.integer "discussable_id"
    t.string "discussable_type"
    t.string "title"
    t.string "discussion_type"
    t.boolean "is_private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussable_id"], name: "index_discussions_on_discussable_id"
    t.index ["discussable_type"], name: "index_discussions_on_discussable_type"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "event_type"
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "is_private"
    t.json "crop_settings"
    t.date "start_date"
    t.date "end_date"
    t.string "shortname"
    t.index ["is_private"], name: "index_events_on_is_private"
    t.index ["shortname"], name: "index_events_on_shortname"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "exhibitions", force: :cascade do |t|
    t.string "title"
    t.string "info"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["event_id"], name: "index_exhibitions_on_event_id"
    t.index ["user_id"], name: "index_exhibitions_on_user_id"
  end

  create_table "flyers", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "user_id"
    t.integer "advertisable_id"
    t.string "advertisable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "quill_content"
    t.boolean "is_default"
    t.index ["advertisable_id"], name: "index_flyers_on_advertisable_id"
    t.index ["advertisable_type"], name: "index_flyers_on_advertisable_type"
    t.index ["user_id"], name: "index_flyers_on_user_id"
  end

  create_table "help_sections", force: :cascade do |t|
    t.string "section"
    t.string "content"
    t.json "quill_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section"], name: "index_help_sections_on_section"
  end

  create_table "icons", force: :cascade do |t|
    t.text "content"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labels", force: :cascade do |t|
    t.string "title"
    t.string "color"
    t.integer "icon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["icon_id"], name: "index_labels_on_icon_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "title"
    t.text "info"
    t.integer "event_id"
    t.string "meeting_type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "location"
    t.boolean "is_private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capacity"
    t.string "external_link"
    t.integer "user_id"
    t.boolean "internal"
    t.boolean "bigblue"
    t.boolean "sata"
    t.index ["event_id"], name: "index_meetings_on_event_id"
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "notification_settings", force: :cascade do |t|
    t.integer "user_id"
    t.json "notification_setting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.integer "source_user_id"
    t.json "target_user_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_type"
    t.boolean "seen"
    t.integer "status"
    t.string "custom_text"
    t.json "target_user_hash"
    t.index ["notifiable_id"], name: "index_notifications_on_notifiable_id"
    t.index ["notifiable_type"], name: "index_notifications_on_notifiable_type"
  end

  create_table "pollings", force: :cascade do |t|
    t.integer "poll_id"
    t.integer "user_id"
    t.integer "outcome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "outcomes"
    t.index ["poll_id"], name: "index_pollings_on_poll_id"
    t.index ["user_id"], name: "index_pollings_on_user_id"
  end

  create_table "polls", force: :cascade do |t|
    t.integer "pollable_id"
    t.string "pollable_type"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer_type"
    t.json "answer_content"
    t.integer "user_id"
    t.index ["pollable_id"], name: "index_polls_on_pollable_id"
    t.index ["pollable_type"], name: "index_polls_on_pollable_type"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "surename"
    t.string "mobile"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "faculty"
    t.json "privacy"
    t.string "country"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "content"
    t.string "questionable_type"
    t.integer "questionable_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_private"
    t.index ["questionable_id"], name: "index_questions_on_questionable_id"
    t.index ["questionable_type"], name: "index_questions_on_questionable_type"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.json "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "default_role"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "title"
    t.boolean "is_private"
    t.string "uuid"
    t.string "secret"
    t.string "pin"
    t.boolean "activated"
    t.json "moderator_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meeting_id"
    t.string "vuuid"
    t.string "vpin"
    t.string "vsecret"
    t.integer "exhibition_id"
    t.string "attendee_password"
    t.string "moderator_password"
    t.index ["exhibition_id"], name: "index_rooms_on_exhibition_id"
    t.index ["is_private"], name: "index_rooms_on_is_private"
    t.index ["meeting_id"], name: "index_rooms_on_meeting_id"
    t.index ["uuid"], name: "index_rooms_on_uuid"
  end

  create_table "subscribers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.string "rfid"
    t.string "current_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_mode"], name: "index_subscribers_on_current_mode"
    t.index ["rfid"], name: "index_subscribers_on_rfid"
    t.index ["room_id"], name: "index_subscribers_on_room_id"
    t.index ["user_id"], name: "index_subscribers_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.string "subscription_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uploads", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.boolean "converted"
    t.integer "user_id"
    t.string "uploadable_type"
    t.integer "uploadable_id"
    t.string "upload_type"
    t.boolean "is_private"
    t.json "crop_settings"
    t.index ["upload_type"], name: "index_uploads_on_upload_type"
    t.index ["uploadable_id"], name: "index_uploads_on_uploadable_id"
    t.index ["uploadable_type"], name: "index_uploads_on_uploadable_type"
    t.index ["uuid"], name: "index_uploads_on_uuid"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "assignments"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "last_code"
    t.datetime "last_code_datetime"
    t.datetime "last_login"
    t.integer "current_role_id"
    t.string "uuid"
    t.boolean "verified"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["verified"], name: "index_users_on_verified"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
