class AddTwitterUsernameToPages < ActiveRecord::Migration
  def change
    add_column :pages, :twitter_username, :string
  end
end
