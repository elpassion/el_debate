class AddCodeUniqueIndexToDebate < ActiveRecord::Migration[5.0]
  def change
    add_index(:debates, :code, unique: true)
  end
end
