class RenameMobileUserToUser < ActiveRecord::Migration[5.0]
  def change
    rename_table :mobile_users, :users
  end
end
