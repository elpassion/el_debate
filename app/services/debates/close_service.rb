module Debates
  class CloseService < DebateService
    def call
      @debate.update!(closed_at: Time.current) unless @debate.closed?
      @message_broadcaster.push(channel, 'status', 'closed')
    end
  end
end
