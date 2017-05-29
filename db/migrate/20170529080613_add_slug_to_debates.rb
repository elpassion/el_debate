class AddSlugToDebates < ActiveRecord::Migration[5.0]
  def change
    add_column :debates, :slug, :string
    add_index :debates, :slug, unique: true
  end
end
