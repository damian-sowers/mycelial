class Project < ActiveRecord::Base

  attr_accessible :project_name, :short_description, :long_description, :other_interesting, :picture, :url, :github_repo, :project_type, :widget_type, :crop_x, :crop_y, :crop_w, :crop_h, :tech_tag_tokens

  belongs_to :page
  has_many :tagowners
  has_many :tech_tags, through: :tagowners
  attr_reader :tech_tag_tokens
  #accepts_nested_attributes_for :tech_tags
  #carrierwave image uploader below
  mount_uploader :picture, PictureUploader

  def tech_tag_tokens=(tokens)
    self.tech_tag_ids = TechTag.ids_from_tokens(tokens)
  end

  # attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  # after_update :crop_avatar

  validates :project_name, presence: 	true,
                           :length => { :maximum => 50 }
  validates :short_description, :length => { :maximum => 500 }
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_format_of :github_repo, :with => URI::regexp(%w(http https))

  # def crop_avatar
  # 	picture.recreate_versions! if crop_x.present?
  # end

end
# == Schema Information
#
# Table name: projects
#
#  id                :integer         not null, primary key
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  project_name      :string(255)
#  short_description :text
#  long_description  :text
#  main_language     :string(255)
#  other_interesting :text
#  picture           :string(255)
#  url               :string(255)
#  github_repo       :string(255)
#  page_id           :integer
#  project_type      :integer
#  widget_type       :integer
#

