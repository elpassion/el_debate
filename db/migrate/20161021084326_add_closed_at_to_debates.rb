class AddClosedAtToDebates < ActiveRecord::Migration[5.0]
  def change
    add_column(:debates, :closed_at, :datetime)
  end
end
