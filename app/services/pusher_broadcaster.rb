module PusherBroadcaster
  def self.push(channel, event, data)
    Pusher.trigger(channel, event,data)
  rescue Pusher::Error
  end
end
