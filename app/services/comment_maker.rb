class CommentMaker
  def initialize(debate, user, notifier)
    @debate   = debate
    @user     = user
    @notifier = notifier
  end

  def self.perform(debate:, user:, params:, notifier: CommentNotifier.new)
    new(debate, user, notifier).call(params)
  end

  def call(params)
    create_comment!(params).tap do |comment|
      @notifier.comment_added(comment: comment, channel: channel)
    end
  end

  private

  def create_comment!(params)
    Comment.create!(
      debate:   @debate,
      user:     @user,
      content:  params.fetch(:content).squish,
      status: status
    )
  end

  def status
    @status ||= @debate.moderate? ? :pending : :accepted
  end

  def channel
    status == :accepted ? "dashboard_channel_#{@debate.code}" : "admin_channel_#{@debate.code}"
  end
end
