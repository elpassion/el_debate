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
    channel.bind 'comment_added', @updateComments

  updateComments: (comment) =>
    @commentsQueue.enq(comment)

class Comment
  constructor: (comment, opts = {}) ->
    @avatarUrl  = comment.user_image_url
    @comment    = comment.content
    @username   = comment.user_name
    @visibleFor = opts.visibleFor || 15000

  render: ->
    element = $('<div>', {class: 'comment z-depth-2 row'})
                .append(@renderUserInfo())
                .append(@renderComment())

    setTimeout ->
      element.remove()
    , @visibleFor

    element

  renderUserInfo: ->
    $('<div>', { class: 'left' })
      .append(
        $('<div>', { class: 'image' })
          .append($('<img>', { src: @avatarUrl }))
      )

  renderComment: ->
    $('<div>', { class: 'content col s10' })
      .append($('<strong>', { text: @username }))
      .append($('<p>', { text: @comment }))

class CommentsFeed
  constructor: (@commentsQueue, @node, opts = {}) ->
    @canAdd        = true
    @lockTime      = opts.lockTime || 5000
    @commentsCount = opts.commentsCount || 1

  run: ->
    setInterval @updateComments, 500

  updateComments: =>
    return unless @canAdd
    @checkForCallToAction()
    return if @commentsQueue.isEmpty()

    currentComments = @node.children(['comment'])
    if currentComments.length == @commentsCount
      currentComments[currentComments.length - 1].remove()

    comment = new Comment(@commentsQueue.deq())
    @node.prepend(comment.render())
    @lock()

  checkForCallToAction: =>
    if @node.children(['comment']).length == 0 && @commentsQueue.isEmpty()
      $('.call-for-action').css('display', 'block')
    else
      $('.call-for-action').css('display', 'none')

  lock: =>
    @canAdd = false
    setTimeout @unlock, @lockTime

  unlock: =>
    @canAdd = true

class SlackFeed
  constructor: (channel, node) ->
    @comments     = new CommentsQueue()
    @slackFeed    = new SlackChannelObserver(@comments)
    @commentsFeed = new CommentsFeed(@comments, node, commentsCount: 2)
    @slackFeed.subscribe(channel)

  run: ->
    @commentsFeed.run()

window.SlackFeed = SlackFeed
