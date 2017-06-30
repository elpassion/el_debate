class DebateNotifier
  def self.build
    new(PusherBroadcaster)
  end

  def initialize(broadcaster, serializer = DashboardSerializer)
    @broadcaster = broadcaster
    @debate_serializer = serializer
  end

  def notify_about_votes(debate, vote_change = {})
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_changed', merge_data(debate, vote_change))
  end

  def notify_about_closing(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_closed', {})
  end

  def notify_about_opening(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_opened', {})
  end

  def notify_about_reset(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_reset', {})
  end

  private

  attr_reader :broadcaster, :debate_serializer

  def merge_data(debate, vote_change)
    debate_serializer.new(debate).to_h.merge(vote_change.to_h)
  end
end
