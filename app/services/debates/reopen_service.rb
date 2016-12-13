module Debates
  class ReopenService < DebateService
    def call
      @debate.update!(closed_at: nil) if @debate.closed?
      @message_broadcaster.push(channel, 'status', 'reopened')
    end
  end
end
