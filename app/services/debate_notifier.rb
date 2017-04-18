class DebateNotifier
  def self.build
    new(PusherBroadcaster)
  end

  def initialize(broadcaster, serializer = DashboardSerializer)
    @broadcaster = broadcaster
    @debate_serializer = serializer
  end

  def notify(debate, vote_change = {})
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_changed', merge_data(debate, vote_change))
  end

  private

  attr_reader :broadcaster, :debate_serializer

  def merge_data(debate, vote_change)
    debate_serializer.new(debate).to_h.merge(vote_change.to_h)
  end
end
