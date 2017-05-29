class AddSlugToDebates < ActiveRecord::Migration[5.0]
  def change
    add_column :debates, :slug, :string
    add_index :debates, :slug, unique: true
  end

  Debate.find_each do |debate|
    debate.generate_slug
    debate.save!
  end
end
