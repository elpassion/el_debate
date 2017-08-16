class DebateNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: DashboardSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def notify_about_votes(debate)
    @broadcaster.push("dashboard_channel_#{debate.code}", 'debate_changed', debate_data(debate))
  end

  def notify_about_closing(debate)
    @broadcaster.push("dashboard_channel_#{debate.code}", 'debate_closed', {})
  end

  def notify_about_opening(debate)
    @broadcaster.push("dashboard_channel_#{debate.code}", 'debate_opened', {})
  end

  def notify_about_reset(debate)
    @broadcaster.push("dashboard_channel_#{debate.code}", 'debate_reset', debate_data(debate))
  end

  private

  def debate_data(debate)
    @serializer.new(debate).to_h
  end
end