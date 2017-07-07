class Slack::CommentMaker < AbstractCommentMaker
  def call(params)
    comment = SlackComment.create!(
      user_id: params[:user_id],
      content: params.fetch(:comment_text).squish,
      debate_id: params.fetch(:debate_id)
    )

    @notifier.call(
      params.fetch(:debate_id),
      comment
    )

    comment
  end
end
