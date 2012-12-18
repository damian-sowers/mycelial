class Page < ActiveRecord::Base

  attr_accessible :name, :hnusername, :linkedin_username, :personal_site, :github_username, :twitter_username, :project_title, :about_text, :image, :remote_image_url, :crop_x, :crop_y, :crop_w, :crop_h, :new_user, :user_name_class
  belongs_to :user
  has_many :projects, :dependent => :destroy
  #carrierwave image uploader below

  mount_uploader :image, ImageUploader

  #cropping functionality requires this below
  #attr_accessor can be used for values you don't want to store in the database. It will only exist for the life of the object
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :new_user

  #after_update :crop_avatar
  
  validates :name, presence: 	true

  def crop_avatar
  	image.recreate_versions! if crop_x.present?
  end
end
# == Schema Information
#
# Table name: pages
#
#  id                :integer         not null, primary key
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  name              :string(255)
#  hnusername        :string(255)
#  linkedin_username :string(255)
#  personal_site     :string(255)
#  github_username   :string(255)
#  user_id           :integer
#  about_text        :text
#  image             :string(255)
#

