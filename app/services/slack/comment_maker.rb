class Slack::CommentMaker < AbstractCommentMaker
  private

  def comment_class
    SlackComment
  end
end
