require 'spec_helper'

describe Comment do
  let(:comment) { Comment.new }

  subject { comment }

  it { should be_valid }

  it { should respond_to :project_id }
  it { should respond_to :user_id }
  it { should respond_to :comment }
  it { should respond_to :parent_id }
  it { should respond_to :ancestry }
  it { should respond_to :username }
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

