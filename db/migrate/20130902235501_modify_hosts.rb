class ModifyHosts < ActiveRecord::Migration
  def up
    add_column :hosts, :has_nse, :boolean
  end

  def down
    remove_column :hosts, :has_nse
  end
end
