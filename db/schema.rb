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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130815010042) do

  create_table "admin_users", :force => true do |t|
    t.string   "first_name",      :limit => 25
    t.string   "last_name",       :limit => 50
    t.string   "email",                         :default => "", :null => false
    t.string   "username",                      :default => "", :null => false
    t.string   "hashed_password", :limit => 90
    t.string   "salt",            :limit => 90
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "data_files", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "hosts", :force => true do |t|
    t.string   "ipv4_address"
    t.string   "ipv6_address"
    t.string   "hostname"
    t.string   "status"
    t.string   "reason"
    t.string   "operating_system", :default => "UNKNOWN", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "xml"
  end

  create_table "ports", :force => true do |t|
    t.integer  "host_id"
    t.string   "port_protocol"
    t.string   "state"
    t.string   "reason"
    t.string   "service_protocol",   :default => "UNKNOWN", :null => false
    t.integer  "portnumber"
    t.string   "service_banner"
    t.string   "service_version"
    t.string   "service_extra_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ports", ["host_id"], :name => "index_ports_on_host_id"
  add_index "ports", ["portnumber"], :name => "index_ports_on_portnumber"
  add_index "ports", ["service_protocol"], :name => "index_ports_on_service_protocol"

  create_table "scripts", :force => true do |t|
    t.integer  "port_id"
    t.integer  "host_id"
    t.string   "script_name",   :default => "UNKNOWN", :null => false
    t.text     "script_output"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scripts", ["host_id"], :name => "index_scripts_on_host_id"
  add_index "scripts", ["port_id"], :name => "index_scripts_on_port_id"

  create_table "xmls", :force => true do |t|
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
