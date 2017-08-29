class CommentSerializer
  def self.serialize(comment)
    new(comment).to_h
  end

  def initialize(comment)
    @comment = comment
  end

  def to_h
    {
      id: comment.id,
      content: comment.content,
      full_name: comment.user_full_name,
      created_at: comment.created_at.to_i * 1000,
      user_initials_background_color: comment.user_initials_background_color,
      user_initials: comment.user_initials,
      user_id: comment.user_id,
      status: comment.status
    }
  end

  def as_json(*)
    to_h
  end

  private

  attr_reader :comment
end
