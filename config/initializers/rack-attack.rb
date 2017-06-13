class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle('api/vote', limit: 2, period: 1.second) do |req|
    if req.path == '/api/vote' && req.post?
      req.env['HTTP_AUTHORIZATION'].presence
    end
  end

  Rack::Attack.throttled_response = lambda do |env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ 'status' => 'request_limit_reached' }.to_json]
    ]
  end
end
