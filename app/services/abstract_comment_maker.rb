class AbstractCommentMaker
  def initialize(notifier)
    @notifier = notifier
  end

  def self.call(params)
    new(CommentNotifier).call(params)
  end

  def call(params)
    comment = create_comment(params)

    @notifier.call(
        params.fetch(:debate_id),
        comment
    )

    comment
  end

  protected

  def create_comment(params)
    raise 'Not implemented!'
  end
end
