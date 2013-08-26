class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
        t.integer "port_id"
        t.integer "host_id"
        t.string "script_name", :default => "UNKNOWN", :null => false
        t.text "script_output"
        t.timestamps :null => true
    end
    add_index("scripts", "port_id")
    add_index("scripts", "host_id")
  end
end
