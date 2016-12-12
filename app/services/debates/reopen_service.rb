module Debates
  class ReopenService < DebateService
    def call
      @debate.reopen!
      @message_broadcaster.push(channel, 'status', 'reopened')
    end
  end
end
