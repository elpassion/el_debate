class DropTableSlackUsers < ActiveRecord::Migration[5.0]
  def change
    drop_table :slack_users do |t|
      t.string :slack_id
      t.string :name
      t.string :image_url
      t.timestamps null: false
    end
  end
end
