class CreateXmls < ActiveRecord::Migration
  def change
    create_table :xmls do |t|
      t.string :file

      t.timestamps
    end
  end
end
