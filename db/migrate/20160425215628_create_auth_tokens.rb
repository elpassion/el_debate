class CreateAuthTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :auth_tokens do |t|
      t.references :debate, index: true
      t.string :value
    end
  end
end
