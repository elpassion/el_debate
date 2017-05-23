class CommentMaker
  def initialize(notifier)
    @notifier = notifier
  end

  def self.call(params)
    new(CommentNotifier).call(params)
  end

  def call(params)
    comment = Comment.create!(
        slack_user_id: params[:user_id],
        content: params.fetch(:comment_text),
        debate_id: params.fetch(:debate_id)
    )

    @notifier.call(
        params.fetch(:debate_id),
        comment
    )

    comment
  end
end
