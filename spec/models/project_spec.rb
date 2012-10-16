require 'spec_helper'

describe Project do
  pending "add some examples to (or delete) #{__FILE__}"
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

