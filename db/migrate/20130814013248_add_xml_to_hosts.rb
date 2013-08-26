class AddXmlToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :xml, :text
  end
end
