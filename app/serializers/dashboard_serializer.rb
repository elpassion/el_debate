class DashboardSerializer
  def initialize(debate, presenter = DebatePresenter)
    @debate = presenter.new(debate)
  end

  def to_h
    {
      id: debate.id,
      topic: debate.topic,
      votes_count: debate.votes.count,
      positive_count: debate.positive_count_with_person,
      negative_count: debate.negative_count_with_person,
      neutral_count: debate.neutral_count,
      positive_percent: debate.positive_percent,
      negative_percent: debate.negative_percent
    }
  end

  private

  attr_reader :debate
end
