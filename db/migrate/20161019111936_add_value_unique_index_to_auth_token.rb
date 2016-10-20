class AddValueUniqueIndexToAuthToken < ActiveRecord::Migration[5.0]
  def change
    add_index(:auth_tokens, :value, unique: true)
  end
end
