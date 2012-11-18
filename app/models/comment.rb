class Comment < ActiveRecord::Base
  attr_accessible :project_id, :user_id, :comment, :parent_id, :username
  belongs_to :project
  belongs_to :user
  has_many :notifications
  has_ancestry
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
#  ancestry   :string(255)
#  username   :string(255)
#

