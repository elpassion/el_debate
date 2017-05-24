class CommentSerializer
  def initialize(comment)
    @comment = comment
  end

  def to_h
    {
      content: comment.content,
      user_image_url: comment.user_image_url,
      user_name: comment.user_name,
      created_at: comment.created_at.to_i
    }
  end

  private

  attr_reader :comment
end
