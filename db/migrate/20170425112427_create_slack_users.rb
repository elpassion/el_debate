class CreateSlackUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :slack_users do |t|
      t.string :slack_id
      t.string :name
      t.string :image_url
      t.timestamps
    end

    add_index :slack_users, :slack_id, unique: true
  end
end
