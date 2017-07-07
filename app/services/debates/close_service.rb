module Debates
  class CloseService < DebateService
    def call
      debate.close
      notify_about_closing
    end

    private

    def notify_about_closing
      notifier.notify_about_closing(debate)
    end
  end
end
