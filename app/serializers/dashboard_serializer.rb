class DashboardSerializer
  def initialize(debate, presenter = DebatePresenter)
    @debate = presenter.new(debate)
  end

  def to_h
    {
      debate: {
        id:               debate.id,
        topic:            debate.topic,
        closed:           debate.closed?,
        status:           debate.status,
        votes_count:      debate.votes_count,
        positive_count:   debate.positive_count,
        negative_count:   debate.negative_count,
        neutral_count:    debate.neutral_count,
        positive_percent: debate.positive_percent,
        negative_percent: debate.negative_percent,
      }
    }
  end

  private

  attr_reader :debate
end
