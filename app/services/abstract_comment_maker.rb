class AbstractCommentMaker
  def initialize(notifier)
    @notifier = notifier
  end

  def self.perform(params)
    new(CommentNotifier).call(params)
  end

  def call(params)
    debate_id = params.fetch(:debate_id)

    comment_class.create!(
      debate_id:  debate_id,
      user_id:    params[:user_id],
      content:    params.fetch(:comment_text).squish
    ).tap do |comment|
      @notifier.call(debate_id, comment)
    end
  end

  private

  def perform
    raise NotImplementedError
  end

  def comment_class
    raise NotImplementedError
  end
end
