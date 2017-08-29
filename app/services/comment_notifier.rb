class CommentNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: CommentSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def send_comment(comment, channel)
    @broadcaster.push(
      channel,
      "comment_added",
      serialize_comment(comment)
    )
  end

  def send_comments(comments, channel)
    @broadcaster.push(
      channel,
      "comments_added",
      comments.map { |comment| serialize_comment(comment) }
    )
  end

  private

  def serialize_comment(comment)
    @serializer.serialize(comment)
  end
end
