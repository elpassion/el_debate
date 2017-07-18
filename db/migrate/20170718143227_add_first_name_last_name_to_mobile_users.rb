class AddFirstNameLastNameToMobileUsers < ActiveRecord::Migration[5.0]
  def change
    add_column MobileUser.table_name, :first_name, :string
    add_column MobileUser.table_name, :last_name, :string
  end
end
