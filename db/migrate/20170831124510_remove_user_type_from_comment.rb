class RemoveUserTypeFromComment < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :user_type
  end
end
