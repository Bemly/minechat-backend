ActiveRecord::Schema[7.2].define(version: 2025_07_17_171231) do
  create_table "members", force: :cascade do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.datetime "joined_at"
    t.integer "unread_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "room_id"
    t.text "content", limit: 1048576
    t.string "message_type", limit: 20
    t.datetime "timestamp"
    t.boolean "read_status", limit: 5, scale: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", limit: 100
    t.integer "creator_id"
    t.string "room_type", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rooms_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", limit: 16
    t.string "nickname", limit: 64
    t.string "email", limit: 100
    t.string "passwd", limit: 255
    t.boolean "online_status", limit: 5, scale: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end
