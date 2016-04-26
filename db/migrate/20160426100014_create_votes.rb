class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :answer, index: true
      t.references :auth_token, index: true
    end
  end
end
