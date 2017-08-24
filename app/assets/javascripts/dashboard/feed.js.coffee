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


class ChannelObserver
  constructor: (@commentsQueue) ->

  subscribe: (channel) ->
    channel.bind 'comment_added', @updateComments

  updateComments: (comment) =>
    @commentsQueue.enq(comment)

class Comment
  constructor: (comment, opts = {}) ->
    @full_name        = comment.user_full_name
    @comment          = comment.content
    @background_color = comment.user_initials_background_color
    @user_initials    = comment.user_initials

  render: ->
    element = $('<div>', {class: 'comment'})
                .append(@renderUserInfo())
                .append(@renderUserName())
                .append(@renderCurrentTime())
                .append(@renderComment())

    element

  renderUserInfo: ->
    $('<div>', { class: 'left' })
      .append(
        $('<div>', { class: 'avatar' })
          .css('background-color', @background_color)
          .append($('<span>', { text: @user_initials, class: 'initials' }))
      )
  renderUserName: ->
    $('<div>', { class: 'username col s8' })
      .append($('<strong>', { text: @full_name }))

  renderCurrentTime: ->
    today = new Date
    minutes = today.getMinutes()
    minutes = (if minutes < 10 then '0' else '') + minutes

    hours = today.getHours()
    hours = if hours >= 0 && hours < 10 then '0' + hours.toString() else hours

    $('<div>', { class: 'time col s8' })
    .append($('<span>', { text: hours + ':' + minutes }))

  renderComment: ->
    $('<div>', { class: 'content' })
      .append($('<p>', { text: @comment }))

class CommentsFeed
  constructor: (@commentsQueue, @node, opts = {}) ->
    @canAdd        = true
    @lockTime      = opts.lockTime || 1000
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
    @node.addClass('moving-feed')

    $comments = @node.find('.comment')
    $newComment = $($comments[0])
    $previousHighestComment = $($comments[1])

    if $previousHighestComment
      $previousHighestComment.css('margin-top', $newComment.outerHeight())
    removeClassCallback = () =>
      @node.removeClass('moving-feed')
      $previousHighestComment.css('margin-top', 0)
    setTimeout(removeClassCallback, 200)
    @lock()
    @removeOldestComment()

  checkForCallToAction: =>
    if @node.children(['comment']).length == 0 && @commentsQueue.isEmpty()
      $('.call-for-action').css('display', 'block')
    else
      $('.call-for-action').css('display', 'none')

  lock: =>
    @canAdd = false
    setTimeout @unlock, @lockTime

  removeOldestComment: =>
    if @node.children(['comment']).length > 10
      @node.children(['comment']).last().remove()

  unlock: =>
    @canAdd = true

class Feed
  constructor: (channel, node) ->
    @comments     = new CommentsQueue()
    @feed         = new ChannelObserver(@comments)
    @commentsFeed = new CommentsFeed(@comments, node, commentsCount: 40)
    @feed.subscribe(channel)

  run: ->
    @commentsFeed.run()

window.Feed = Feed
