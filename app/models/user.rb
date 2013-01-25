class User < ActiveRecord::Base
  before_save :transform_username_to_lowercase
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :page, :dependent => :destroy
  #this has_many association give me the ability to find all projects of a user just by their user_id. (skip going through page)
  has_many :projects, :through => :page
  has_many :notifications
  has_many :comments
  has_many :likes
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me
  
  VALID_USERNAME_REGEX = /^[a-z0-9\-_]+$/i
  validates :username, presence:   true,
                    format:     { with: VALID_USERNAME_REGEX },
                    uniqueness: { case_sensitive: false },
                    length: { within: 4..18 }
  def to_param
  	id || username	
	end

  private

    def transform_username_to_lowercase
      self.username = self.username.downcase
    end

    def send_welcome_email
      user_email = User.find(self.id).email
      Welcome.send_welcome_email(user_email).deliver
    end
end
# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  username               :string(255)
#

