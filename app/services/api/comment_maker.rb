class Api::CommentMaker < AbstractCommentMaker
  private

  def create_comment(params)
    Comment.create!(
        content: params.fetch(:comment_text),
        debate_id: params.fetch(:debate_id)
    )
  end
end
