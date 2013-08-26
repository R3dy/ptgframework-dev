class CreatePorts < ActiveRecord::Migration
  def change
    create_table :ports do |t|
        t.integer "host_id"
        t.string "port_protocol"
        t.string "state"
        t.string "reason"
        t.string "service_protocol", :default => "UNKNOWN", :null => false
        t.integer "portnumber"
        t.string "service_banner"
        t.string "service_version"
        t.string "service_extra_info"
        t.timestamps :null => true
    end
    add_index("ports", "host_id")
    add_index("ports", "service_protocol")
    add_index("ports", "portnumber")
  end
end
