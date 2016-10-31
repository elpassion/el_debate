module Debates
  class CloseService
    def initialize(debate:, message_broadcaster: PusherBroadcaster)
      @debate = debate
      @message_broadcaster = message_broadcaster
    end

    def call
      @debate.close!
      @message_broadcaster.push(channel, 'status', 'closed')
    end

    private

    attr_reader :debate

    def channel
      "dashboard_channel_#{debate.id}"
    end
  end
end
