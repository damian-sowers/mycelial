class Hacker < ActiveRecord::Base
  attr_accessible :name, :hnusername, :linkedin_username, :personal_site, :github_username, :project_title
  belongs_to :user
  has_many :projects
  
  validates :name, presence: 	true
end
# == Schema Information
#
# Table name: hackers
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
#

