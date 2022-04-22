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

ActiveRecord::Schema.define(version: 2022_04_22_200703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "away_matches", force: :cascade do |t|
    t.integer "tour"
    t.string "home_team"
    t.string "result"
    t.string "away_team"
    t.bigint "tournament_club_id", null: false
    t.datetime "match_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_club_id"], name: "index_away_matches_on_tournament_club_id"
  end

  create_table "aways", force: :cascade do |t|
    t.integer "tour"
    t.string "home_team"
    t.string "result"
    t.string "away_team"
    t.bigint "tournament_club_id", null: false
    t.datetime "match_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_club_id"], name: "index_aways_on_tournament_club_id"
  end

  create_table "coaches", force: :cascade do |t|
    t.string "name"
    t.bigint "tournament_club_id", null: false
    t.integer "age"
    t.string "country"
    t.date "appointed"
    t.date "contract_until"
    t.float "average_term"
    t.string "preferred_formation"
    t.string "last_club"
    t.text "achievements"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_club_id"], name: "index_coaches_on_tournament_club_id"
  end

  create_table "home_matches", force: :cascade do |t|
    t.integer "tour"
    t.string "home_team"
    t.string "result"
    t.string "away_team"
    t.bigint "tournament_club_id", null: false
    t.datetime "match_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_club_id"], name: "index_home_matches_on_tournament_club_id"
  end

  create_table "homes", force: :cascade do |t|
    t.integer "tour"
    t.string "home_team"
    t.string "result"
    t.string "away_team"
    t.bigint "tournament_club_id", null: false
    t.datetime "match_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tournament_club_id"], name: "index_homes_on_tournament_club_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.integer "number"
    t.integer "age"
    t.string "country"
    t.bigint "tournament_club_id", null: false
    t.float "market_value"
    t.string "last_club"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "foot"
    t.date "joined"
    t.date "contract_until"
    t.float "height"
    t.index ["tournament_club_id"], name: "index_players_on_tournament_club_id"
  end

  create_table "tournament_clubs", force: :cascade do |t|
    t.string "club"
    t.integer "points"
    t.integer "place"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "average_age"
    t.float "total_market_value"
    t.string "english_name"
    t.string "stadium"
    t.text "achievements"
    t.integer "squad_size"
    t.integer "national_team_players"
    t.integer "foreigners"
    t.date "founded"
  end

  add_foreign_key "away_matches", "tournament_clubs"
  add_foreign_key "aways", "tournament_clubs"
  add_foreign_key "coaches", "tournament_clubs"
  add_foreign_key "home_matches", "tournament_clubs"
  add_foreign_key "homes", "tournament_clubs"
  add_foreign_key "players", "tournament_clubs"
end
