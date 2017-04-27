class CommentsQueue
  constructor: ->
    @comments = []

  enq: (comment) ->
    @_add(comment)
    @_sort()

  deq: ->
    @comments.shift()

  isEmpty: ->
    @comments.length == 0

  _add: (comment) ->
    @comments.push(comment)

  _sort: ->
    @comments.sort (a, b) ->
      a.created_at - b.created_at


class SlackChannelObserver
  constructor: (@commentsQueue) ->

  subscribe: (channel) ->
    channel.bind 'newComment', @updateComments

  updateComments: (data) =>
    @commentsQueue.enq(data.comment)

class Comment
  constructor: (comment) ->
    @avatarUrl = comment.user_image_url
    @comment   = comment.content
    @username  = comment.user_name

  render: ->
    $('<div>', {class: 'card horizontal'})
      .append(
        $('<div>', { class: 'card-image' } )
          .append($('<img>', { src: @avatarUrl }))
      )
      .append(
        $('<div>', { class: 'card-stacked' })
          .append(
            $('<div>', { class: 'card-content' })
              .append($('<strong>', { text: @username }))
              .append($('<p>', { text: @comment }))
          )
      )

class CommentsFeed
  constructor: (@commentsQueue, @node, opts = {}) ->
    @canAdd        = true
    @lockTime      = opts.lockTime || 5000
    @commentsCount = opts.commentsCount || 1

  run: ->
    setInterval @updateComments, 500

  updateComments: =>
    return unless @canAdd
    return if @commentsQueue.isEmpty()

    currentComments = @node.children()
    if currentComments.length == @commentsCount
      currentComments[currentComments.length - 1].remove()

    comment = new Comment(@commentsQueue.deq())
    @node.prepend(comment.render())
    @lock()

  lock: =>
    @canAdd = false
    setTimeout @unlock, @lockTime

  unlock: =>
    @canAdd = true


class CommentsProducer
  constructor: ->
    @subscribers = []
    @interval    = null

  bind: (evt, subscriber) ->
    @subscribers.push(subscriber)

  run: ->
    @interval = setInterval @pushComment, 1500
    setTimeout =>
      clearInterval(@interval)
    , 20000

  pushComment: =>
    time    = parseInt((new Date()).getTime() / 1000)
    comment = {
      created_at:     time,
      content:        "new comment at: #{time}",
      user_name:      "username",
      user_image_url: "http://lorempixel.com/96/96/people/"
    }
    subscriber({comment: comment}) for subscriber in @subscribers

class SlackFeed
  constructor: (channel, node) ->
    @comments     = new CommentsQueue()
    @slackFeed    = new SlackChannelObserver(@comments)
    @commentsFeed = new CommentsFeed(@comments, node)
    @slackFeed.subscribe(channel)

  run: ->
    @commentsFeed.run()

window.SlackFeed = SlackFeed

$(document).ready ->
  commentsProducer = new CommentsProducer()
  slackFeed        = new SlackFeed(commentsProducer, $('#slack-comments .comments'))
  slackFeed.run()
  commentsProducer.run()
