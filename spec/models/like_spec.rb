require 'spec_helper'

describe Like do
  let(:like) { Like.new }

  it { should respond_to :user_id }
  it { should respond_to :project_id }
  it { should respond_to :username }
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

