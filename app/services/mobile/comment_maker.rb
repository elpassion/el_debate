class Mobile::CommentMaker < AbstractCommentMaker
  def call(params)
    comment = MobileComment.create!(
        user_id: params[:user_id],
        content: params.fetch(:comment_text),
        debate_id: params.fetch(:debate_id)
    )

    @notifier.call(
        params.fetch(:debate_id),
        comment
    )

    comment
  end
end
