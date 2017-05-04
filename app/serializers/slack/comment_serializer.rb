class Slack::CommentSerializer
  def initialize(comment)
    @comment = comment
  end

  def to_h
    {
      content: @comment.content,
      user_name: @comment.slack_user_name,
      user_image_url: @comment.slack_user_image_url,
      created_at: @comment.created_at.to_i
    }
  end
end
