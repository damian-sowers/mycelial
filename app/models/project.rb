class Project < ActiveRecord::Base

  attr_accessible :project_name, :short_description, :long_description, :other_interesting, :picture, :url, :github_repo, :project_type, :crop_x, :crop_y, :crop_w, :crop_h, :tech_tag_tokens, :image_width, :image_height, :likes_count, :tag_list

  belongs_to :page
  has_many :tagowners
  has_many :tech_tags, through: :tagowners
  has_many :comments
  has_many :likes
  attr_reader :tech_tag_tokens
  acts_as_taggable
  #accepts_nested_attributes_for :tech_tags
  #carrierwave image uploader below
  mount_uploader :picture, PictureUploader
  before_save :save_image_dimensions

  def tech_tag_tokens=(tokens)
    self.tech_tag_ids = TechTag.ids_from_tokens(tokens)
  end

  validates :project_name, presence: 	true,
                           :length => { :maximum => 50 }
  validates :short_description, :length => { :maximum => 500 }
   
  #might need to fix these url validators. Can't use them until they can accept blank entries 
  #validates_format_of :url, :with => URI::regexp(%w(http https)) 
  #validates_format_of :github_repo, :with => URI::regexp(%w(http https))

  private 

    def save_image_dimensions
      if picture_changed? && remove_picture != true
        self.image_width  = picture.geometry[:width]
        self.image_height = picture.geometry[:height]
      end
      # binding.remote_pry
    end

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

