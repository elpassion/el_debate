module Debates
  class OpenService < DebateService
    def call
      debate.open
      notify_about_opening
    end
  end
end
