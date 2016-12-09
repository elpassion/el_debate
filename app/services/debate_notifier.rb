class DebateNotifier
  def initialize(broadcaster, serializer = DashboardSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def notify(debate, change_hash)
    broadcaster.push("dashboard_channel_#{debate.id}",
                     'vote',
                     serializer.new(debate, change_hash).to_h)
  end

  private

  attr_reader :broadcaster, :serializer
end
