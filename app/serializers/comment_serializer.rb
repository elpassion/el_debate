class CommentSerializer
  def initialize(comment)
    @comment = comment
  end

  def to_h
    {
      content: comment.content,
      user_name: comment.user_name,
      first_name: comment.user_first_name,
      last_name: comment.user_last_name,
      created_at: comment.created_at.to_i,
      user_initials_avatar_color: comment.user_avatar_color,
      user_initials: comment.user_initials
    }
  end

  private

  attr_reader :comment
end
