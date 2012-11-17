require 'spec_helper'

describe Comment do
  pending "add some examples to (or delete) #{__FILE__}"
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

