class RenameSlackComments < ActiveRecord::Migration[5.0]
  def change
    rename_table :slack_comments, :comments
  end
end
