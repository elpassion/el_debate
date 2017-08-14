class AddModerateToDebate < ActiveRecord::Migration[5.0]
  def change
    add_column Debate.table_name, :moderate, :boolean, default: true
  end
end
