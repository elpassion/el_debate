class CommentNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: CommentSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def comment_added(comment:, channel:)
    send_comment(comment: comment, channel: channel)
  end

  def comments_added(comments:, channel:)
    send_comments(comments: comments, channel: channel)
  end

  def comment_rejected(comment:, channel:)
    send_comment(comment: comment, channel: channel, event: 'comment_rejected')
  end

  private

  def send_comment(comment:, channel:, event: 'comment_added')
    @broadcaster.push(
      channel,
      event,
      serialize_comment(comment)
    )
  end

  def send_comments(comments:, channel:, event: 'comments_added')
    @broadcaster.push(
      channel,
      event,
      comments.map { |comment| serialize_comment(comment) }
    )
  end

  def serialize_comment(comment)
    @serializer.serialize(comment)
  end
end
