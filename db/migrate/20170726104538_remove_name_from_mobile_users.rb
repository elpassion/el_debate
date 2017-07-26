class RemoveNameFromMobileUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :mobile_users, :name
  end
end
