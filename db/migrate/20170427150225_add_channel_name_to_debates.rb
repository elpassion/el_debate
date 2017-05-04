class AddChannelNameToDebates < ActiveRecord::Migration[5.0]
  def change
    add_column :debates, :channel_name, :string
    add_index :debates, :channel_name
  end
end
