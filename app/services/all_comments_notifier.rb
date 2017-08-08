class AllCommentsNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: GetComments, mobile_user:)
    @broadcaster = broadcaster
    @serializer = serializer
    @user = mobile_user
  end

  def self.perform(mobile_user, debate)
    new(mobile_user: mobile_user).call(debate)
  end

  def call(debate)
    @broadcaster.push(
      "dashboard_channel_#{debate_id}_#{@user.id}",
      "all_comments_sent",
      @serializer.new(debate.id).to_h
    )
  end
end
