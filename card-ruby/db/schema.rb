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

ActiveRecord::Schema.define(version: 2020_02_29_030302) do

  create_table "card_effects", force: :cascade do |t|
    t.string "name"
    t.string "effectclass"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "card_effects_maps", force: :cascade do |t|
    t.integer "cardid"
    t.integer "effectid"
    t.integer "count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "card_games", force: :cascade do |t|
    t.string "code"
    t.string "userid"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deck_cards", force: :cascade do |t|
    t.integer "deckid"
    t.string "name"
    t.string "cardclass"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deck_data", force: :cascade do |t|
    t.string "name"
    t.string "deckclass"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "game_decks", force: :cascade do |t|
    t.integer "gameid"
    t.integer "deckid"
    t.string "userid"
    t.boolean "isselected"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "game_players", force: :cascade do |t|
    t.integer "gameid"
    t.string "userid"
    t.integer "deckid"
    t.integer "position"
    t.integer "health"
    t.integer "status"
    t.boolean "hasturn"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pile_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "player_cards", force: :cascade do |t|
    t.integer "playerid"
    t.integer "cardid"
    t.integer "o_deckid"
    t.integer "cur_deckid"
    t.integer "pile_type"
    t.integer "card_health"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
