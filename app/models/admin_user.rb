class AdminUser < ActiveRecord::Base
    attr_accessible :first_name, :last_name, :email, :hashed_password, :username, :salt
    # To configure a different table name
    # set_table_name("admin_users")
    scope :named, lambda {|first,last| where(:first_name => first, :last_name => last)}

    validates_length_of :password, :within => 8..25, :on => :create

    attr_protected :hashed_password, :salt

    attr_accessor :password
    before_save :create_hashed_password
    after_save :clear_password

    def self.make_salt(username="")
        Digest::SHA2.hexdigest("Here #{username} have some #{Time.now} efffin salt!")
    end

    def self.hash_with_salt(password="", salt="")
        Digest::SHA2.hexdigest("Salt + encrypted #{salt} with the #{password}!_")
    end

    def self.authenticate(username="", password="")
      user = AdminUser.find_by_username(username)
      if user && user.password_match?(password)
        return user
      else
        return false
      end
    end

    def password_match?(password="")
      hashed_password == AdminUser.hash_with_salt(password, salt)
    end

    private
    def create_hashed_password
      unless password.blank?
        self.salt = AdminUser.make_salt(username) if salt.blank?
        self.hashed_password = AdminUser.hash_with_salt(password, salt)
      end
    end
    def clear_password
      self.password = nil
    end
end
