class CreateAdminUsers < ActiveRecord::Migration

    def up
        create_table :admin_users do |t|
            t.string "first_name", :limit => 25
            t.string "last_name", :limit => 50
            t.string "email", :default => "", :null => false
            t.string "username", :default => "", :null => false
            t.string "hashed_password", :limit => 90
            t.string "salt", :limit => 90
            t.timestamps
        end
    end

    def down
        drop_table :admin_users
    end

end

