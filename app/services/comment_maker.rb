class CommentMaker
  def initialize(debate, user, notifier)
    @debate   = debate
    @user     = user
    @notifier = notifier
  end

  def self.perform(debate:, user:, comment_class:, params:, notifier: CommentNotifier.new)
    new(debate, user, notifier).call(comment_class, params)
  end

  def call(comment_class, params)
    create_comment!(comment_class, params).tap do |comment|
      @notifier.call(@debate, comment)
    end
  end

  private

  def create_comment!(comment_class, params)
    comment_class.create!(
      debate:   @debate,
      user:     @user,
      content:  params.fetch(:content).squish
    )
  end
end
