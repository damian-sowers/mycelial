class BetaInvite < ActiveRecord::Base
  attr_accessible :email

  validates :email, presence: 	true,
  									uniqueness: { case_sensitive: false }
end
