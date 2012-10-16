class Tagowner < ActiveRecord::Base
  belongs_to :project
  belongs_to :tech_tag
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

