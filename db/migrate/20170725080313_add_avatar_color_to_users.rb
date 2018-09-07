class AddAvatarColorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :mobile_users, :avatar_color, :string
  end
end
