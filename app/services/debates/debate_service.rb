module Debates
  class DebateService
    def initialize(debate:, notifier: DebateNotifier.new)
      @debate   = debate
      @notifier = notifier
    end

    private

    attr_reader :debate, :notifier
  end
end
