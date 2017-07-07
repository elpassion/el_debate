class CommentNotifier
  def initialize(broadcaster, serializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def self.perform(debate_id, comment, broadcaster: PusherBroadcaster.new, serializer: CommentSerializer)
    new(broadcaster).call(debate_id, comment)
  end

  def call(debate_id, comment)
    @broadcaster.push(
      "dashboard_channel_#{debate_id}",
      "comment_added",
      @serializer.new(comment).to_h
    )
  end
end