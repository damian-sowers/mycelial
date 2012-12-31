class AddEmailToBetaInvites < ActiveRecord::Migration
  def change
    add_column :beta_invites, :email, :string
  end
end
