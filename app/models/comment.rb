class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :project
end
# == Schema Information
#
# Table name: comments
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  project_id :integer
#  user_id    :integer
#  comment    :text
#

