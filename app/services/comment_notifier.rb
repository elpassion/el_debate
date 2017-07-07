class CommentNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: CommentSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def call(debate, comment)
    @broadcaster.push(
      "dashboard_channel_#{debate.id}",
      "comment_added",
      @serializer.new(comment).to_h
    )
  end
end