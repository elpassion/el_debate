class AddDebateIdToSlackComments < ActiveRecord::Migration[5.0]
  def change
    add_column :slack_comments, :debate_id, :integer
    add_index :slack_comments, :debate_id
  end
end
