class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :hacker

  validates :project_name, presence: 	true
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
#  hacker_id          :integer
#

