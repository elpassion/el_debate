module Debates
  class OpenService < DebateService
    def call
      debate.open
      notify_about_opening
    end

    private

    def notify_about_opening
      notifier.notify_about_opening(debate)
    end
  end
end
