class CreateSlackComments < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_comments do |t|
      t.integer :slack_user_id
      t.text :content
      t.timestamps
    end

    add_index :slack_comments, :slack_user_id
  end
end
