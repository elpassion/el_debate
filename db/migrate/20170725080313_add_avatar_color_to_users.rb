class AddAvatarColorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column MobileUser.table_name, :avatar_color, :string
  end
end
