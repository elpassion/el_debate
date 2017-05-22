class Slack::CommentMaker < AbstractCommentMaker
  private

  def create_comment(params)
    Slack::Comment.create!(
        slack_user_id: params.fetch(:user_id),
        content: params.fetch(:comment_text),
        debate_id: params.fetch(:debate_id)
    )
  end
end
