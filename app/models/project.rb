class Project < ActiveRecord::Base
  attr_accessible :project_name, :short_description, :long_description, :main_language, :other_technologies, :picture, :url, :github_repo, :crop_x, :crop_y, :crop_w, :crop_h

  belongs_to :page

  #carrierwave image uploader below
  mount_uploader :picture, PictureUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  validates :project_name, presence: 	true

  def crop_avatar
  	picture.recreate_versions! if crop_x.present?
  end

end
# == Schema Information
#
# Table name: projects
#
#  id                 :integer         not null, primary key
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  project_name       :string(255)
#  short_description  :text
#  long_description   :text
#  main_language      :string(255)
#  other_technologies :text
#  picture            :string(255)
#  url                :string(255)
#  github_repo        :string(255)
#  page_id            :integer
#

