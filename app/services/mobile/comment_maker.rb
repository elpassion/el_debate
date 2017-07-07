class Mobile::CommentMaker < AbstractCommentMaker
  private

  def comment_class
    MobileComment
  end
end
