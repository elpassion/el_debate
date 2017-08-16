class CommentNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: CommentSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def call(comment, channel)
    @broadcaster.push(
      channel,
      "comment_added",
      @serializer.new(comment).to_h
    )
  end

  def send_comments(debate_id, comments)
    @broadcaster.push(
      "dashboard_channel_multiple_#{Debate.find(debate_id)[:code]}",
      "comments_added",
      comments
    )
  end
end
