class Slack::CommentNotifier
  def initialize(broadcaster)
    @broadcaster = broadcaster
  end

  def self.call(debate_id, comment)
    new(PusherBroadcaster).call(debate_id, comment)
  end

  def call(debate_id, comment)
    @broadcaster.push(
      "dashboard_channel_#{debate_id}",
      "comment_added",
      Slack::CommentSerializer.new(comment).to_h
    )
  end
end
