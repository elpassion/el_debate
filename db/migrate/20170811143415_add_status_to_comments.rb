class AddStatusToComments < ActiveRecord::Migration[5.0]
  def change
    add_column Comment.table_name, :status, :integer, default: 0
  end
end
