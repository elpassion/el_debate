class DebateNotifier
  def initialize(broadcaster, serializer = DashboardSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def notify(debate)
    broadcaster.push("dashboard_channel_#{debate.id}", 'vote', serializer.new(debate).to_h)
  end

  private

  attr_reader :broadcaster, :serializer
end
