class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string "ipv4_address"
      t.string "ipv6_address"
      t.string "hostname"
      t.string "status"
      t.string "reason"
      t.string "operating_system", :default => "UNKNOWN", :null => false
      t.timestamps :null => true
    end
  end

end
