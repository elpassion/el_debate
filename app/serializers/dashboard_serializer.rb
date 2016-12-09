class DashboardSerializer
  def initialize(debate, change_hash, presenter = DebatePresenter)
    @debate = presenter.new(debate)
    @change_hash = change_hash
  end

  def to_h
    {
      id: debate.id,
      topic: debate.topic,
      votes_count: debate.votes_count,
      positive_count: debate.positive_count,
      negative_count: debate.negative_count,
      neutral_count: debate.neutral_count,
      positive_percent: debate.positive_percent,
      negative_percent: debate.negative_percent,
      positive_change: change_hash[:positive],
      negative_change: change_hash[:negative]
    }
  end

  private

  attr_reader :debate, :change_hash
end
