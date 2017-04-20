module Debates
  class ReopenService < DebateService
    def call(reopen_for: 1.hour)
      debate.update!(closed_at: Time.current + reopen_for) if debate.closed?
      notify
    end
  end
end
