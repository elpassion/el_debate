module Debates
  class DebateService
    def initialize(debate:, notifier: DebateNotifier.build)
      @debate   = debate
      @notifier = notifier
    end

    private

    attr_reader :debate, :notifier

    def notify_about_votes
      notifier.notify_about_votes(debate)
    end

    def notify_about_closing
      notifier.notify_about_closing(debate)
    end

    def notify_about_opening
      notifier.notify_about_opening(debate)
    end
  end
end
