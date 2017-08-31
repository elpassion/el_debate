class RemoveChannelNameFromDebate < ActiveRecord::Migration[5.0]
  def change
    remove_column :debates, :channel_name
  end
end
