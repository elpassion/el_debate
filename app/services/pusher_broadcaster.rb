class PusherBroadcaster
  def push(channel, event, data)
    Pusher.trigger(channel, event, data)
  rescue Pusher::Error
  end
end
