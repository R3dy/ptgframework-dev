class AddToHosts < ActiveRecord::Migration
  def up
    add_column :hosts, :has_open_ports, :boolean
  end

  def down
    remove_column :hosts, :has_open_ports
  end
end
