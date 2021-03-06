# == Schema Information
# Schema version: 20110304163617
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, :dependent => :destroy

  email_regex =  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence   => true,
                    :length     => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  before_save :encrypt_password

  def  has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

# user.microposts but inside the object the user is 'self'
# can also leave off the self
#  change:  self.microposts
#      to:  microposts
# this will not Generalize, so new syntax in Rails 3
# now also, change to using Rails 3  "user_id = ?" 
#      to:  Micropost.where("user_id = ?", self.id)
# the 'where' does a conditional find
  def feed
    Micropost.where("user_id = ?", id)
  end


  # class method to call authenticate
  #  self.find_by_email 

  class << self

    def authenticate(email, submitted_password)
      user = find_by_email(email)
      #return nil  if user.nil?
      #return user if user.has_password?(submitted_password)
      ### refactor two above with Terary Oper as below
      (user && user.has_password?(submitted_password)) ? user : nil
    end

    # In class method there is no 'salt' as #{salt} from User below
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end

  private 

    def encrypt_password
       self.salt = make_salt if new_record?
       self.encrypted_password = encrypt(password)
    end

    def  encrypt(string)
         secure_hash("#{salt}--#{string}")
    end

    def make_salt
       secure_hash("#{Time.now.utc}--#{password}")
    end

    def  secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
