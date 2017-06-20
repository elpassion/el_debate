class ChangeCommentToBeSingleInherit < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :type, :string
    rename_column :comments, :slack_user_id, :user_id
  end
end
