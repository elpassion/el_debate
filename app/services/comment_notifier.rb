class CommentNotifier
  def initialize(broadcaster: PusherBroadcaster.new, serializer: CommentSerializer)
    @broadcaster = broadcaster
    @serializer = serializer
  end

  def send_comment(comment:, channel:, event: 'comment_added')
    @broadcaster.push(
      channel,
      event,
      serialize_comment(comment)
    )
  end

  def send_comments(comments:, channel: , event: 'comments_added')
    @broadcaster.push(
      channel,
      event,
      comments.map { |comment| serialize_comment(comment) }
    )
  end

  private

  def serialize_comment(comment)
    @serializer.serialize(comment)
  end
end
