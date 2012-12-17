class AddUserNameClassToPages < ActiveRecord::Migration
  def change
    add_column :pages, :user_name_class, :string
  end
end
