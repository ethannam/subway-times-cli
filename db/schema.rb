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

ActiveRecord::Schema.define(version: 2019_02_14_192730) do

  create_table "arrivals", force: :cascade do |t|
    t.datetime "time"
    t.integer "train_id"
    t.integer "station_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "station_id"
    t.string "label"
  end

  create_table "line_stations", force: :cascade do |t|
    t.integer "line_id"
    t.integer "station_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "name"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.string "stop_id"
    t.boolean "location_type"
    t.string "parent_station"
  end

  create_table "trains", force: :cascade do |t|
    t.boolean "express"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
  end

end
