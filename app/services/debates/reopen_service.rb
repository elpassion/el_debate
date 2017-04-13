module Debates
  class ReopenService < DebateService
    def call(reopen_for: 1.hour)
      @debate.update!(closed_at: Time.current + 1.hour) if @debate.closed?
      @message_broadcaster.push(channel, 'status', 'reopened')
    end
  end
end
