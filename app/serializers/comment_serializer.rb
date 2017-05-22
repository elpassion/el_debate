class CommentSerializer
  def initialize(comment)
    @comment = comment
  end

  def to_h
    {
      content: comment.content,
      user_image_url: user.image_url,
      user_name: user.name,
      created_at: comment.created_at.to_i
    }
  end

  private

  attr_reader :comment

  def user
    comment.user || anonymous_user
  end

  def anonymous_user
    OpenStruct.new(image_url: '/assets/dashboard/default_user.png', name: 'Anonymous')
  end
end
