module Debates
  class CloseService < DebateService
    def call
      debate.close
      notify_about_closing
    end
  end
end
