module Debates
  class DebateService
    def initialize(debate:, notifier: DebateNotifier.build)
      @debate   = debate
      @notifier = notifier
    end

    private

    attr_reader :debate, :notifier

    def notify
      notifier.notify(debate)
    end
  end
end
