class AddAuthTokenToMobileUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :mobile_users, :auth_token, foreign_key: true
  end
end
