class AbstractCommentMaker
  def initialize(notifier)
    @notifier = notifier
  end

  def self.perform(params)
    new(CommentNotifier).call(params)
  end

  private

  def perform
    raise 'not implemented'
  end
end
