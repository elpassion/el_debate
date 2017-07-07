class DebateNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: DashboardSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def notify_about_votes(debate, vote_change = {})
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_changed', debate_change_data(debate, vote_change))
  end

  def notify_about_closing(debate)
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_closed', {})
  end

  def notify_about_opening(debate)
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_opened', {})
  end

  def notify_about_reset(debate)
    @broadcaster.push("dashboard_channel_#{debate.id}", 'debate_reset', debate_data(debate))
  end

  private

  def debate_data(debate)
    @serializer.new(debate).to_h
  end

  def debate_change_data(debate, vote_change)
    debate_data(debate).merge(vote_change.to_h)
  end
end