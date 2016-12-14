module Debates
  class DebateService
    def initialize(debate:, message_broadcaster: PusherBroadcaster)
      @debate = debate
      @message_broadcaster = message_broadcaster
    end

    private

    attr_reader :debate

    def channel
      "dashboard_channel_#{debate.id}"
    end
  end
end