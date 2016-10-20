module PusherBroadcaster
  def self.push!(data)
    Pusher.trigger('dashboard_channel', 'vote', data)
  end
end
