class ChangeClosedAtToIsClosedBoolean < ActiveRecord::Migration[5.0]
  def up
    add_column :debates, :closed, :boolean, null: false, default: false

    Debate.all.each do |debate|
      debate.closed = debate.closed_at < Time.current ? true : false
      debate.save
    end
    remove_column :debates, :closed_at
  end

  def down
    add_column :debates, :closed_at, :datetime
    Debate.reset_column_information

    Debate.all.each do |debate|
      debate.closed_at = Time.current if debate.closed?
      debate.save
    end

    remove_column :debates, :closed
  end
end
