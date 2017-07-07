class DebateNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: DashboardSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def notify_about_votes(debate, vote_change = {})
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_changed', merge_data(debate, vote_change))
  end

  def notify_about_closing(debate)
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_closed', {})
  end

  def notify_about_opening(debate)
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_opened', {})
  end

  private

  def merge_data(debate, vote_change)
    @serializer.new(debate).to_h.merge(vote_change.to_h)
  end
end
