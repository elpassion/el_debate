module Debates
  class CloseService < DebateService
    def call
      @debate.close!
      @message_broadcaster.push(channel, 'status', 'closed')
    end
  end
end
