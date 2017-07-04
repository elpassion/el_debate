class DebateNotifier
  def self.build
    new(PusherBroadcaster)
  end

  def initialize(broadcaster, serializer = DashboardSerializer)
    @broadcaster = broadcaster
    @debate_serializer = serializer
  end

  def notify_about_votes(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_changed', debate_data(debate))
  end

  def notify_about_closing(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_closed', {})
  end

  def notify_about_opening(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'debate_opened', {})
  end

  private

  attr_reader :broadcaster, :debate_serializer

  def debate_data(debate)
    debate_serializer.new(debate).to_h
  end
end
