class FakeChannel
  bind: (event, callback) ->

class FakePusher
  subscribe: (channel) ->
    new FakeChannel

class @PusherFactory
  @create: ->
    if Environment.env == 'test'
      new FakePusher
    else
      new Pusher(
        Environment.pusherAppKey,
        { cluster: Environment.pusherAppCluster, encrypted: true }
      )
