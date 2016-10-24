class AddVotesCountToAnswer < ActiveRecord::Migration[5.0]
  class Vote < ActiveRecord::Base; end
  def self.up
    add_column :answers, :votes_count, :integer, null: false, default: 0
    # reset cached counts for answers with votes only
    ids = Set.new
    Vote.find_each {|v| ids << v.answer_id}
    ids.each do |answer_id|
      Answer.reset_counters(answer_id, :votes)
    end
  end
  def self.down
    remove_column :answers, :votes_count
  end
end
