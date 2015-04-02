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

ActiveRecord::Schema.define(version: 20150402211328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bus_routes", force: true do |t|
    t.string "sch_routeid"
    t.string "rtd_agencyrouteid"
  end

  create_table "legs", force: true do |t|
    t.string   "mode"
    t.string   "start_location"
    t.string   "end_location"
    t.float    "distance"
    t.float    "emissions"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trip_id"
    t.string   "direction"
    t.string   "route"
    t.integer  "user_id"
  end

  create_table "pattern_stops", force: true do |t|
    t.string "sch_stoppointseqno"
    t.string "sch_patternid"
    t.string "cpt_stoppointid"
  end

  create_table "patterns", force: true do |t|
    t.string "sch_patternid"
    t.string "sch_routeid"
  end

  create_table "stops", force: true do |t|
    t.string "cpt_stoppointid"
    t.string "sp_longitude"
    t.string "sp_latitude"
  end

  create_table "trips", force: true do |t|
    t.string   "user"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
