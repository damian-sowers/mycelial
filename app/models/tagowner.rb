class Tagowner < ActiveRecord::Base
  #has_many :tech_tags
  belongs_to :tech_tag
  belongs_to :project
end
# == Schema Information
#
# Table name: tagowners
#
#  id          :integer         not null, primary key
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  project_id  :integer
#  tech_tag_id :integer
#

