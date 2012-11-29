class Like < ActiveRecord::Base
  attr_accessible :user_id, :project_id, :username
  
  belongs_to :project
  belongs_to :user
end
# == Schema Information
#
# Table name: likes
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  user_id    :integer
#  project_id :integer
#  username   :string(255)
#

