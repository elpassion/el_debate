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

  subscribe_multiple: (channel) ->
    channel.bind 'comments_added', @updateCommentsMultiple

  updateCommentsMultiple: (comments) =>
    for comment in comments
      @updateComments(comment)

  updateComments: (comment) =>
    @commentsQueue.enq(comment)

class Comment
  constructor: (comment) ->
    @full_name        = comment.full_name
    @comment          = comment.content
    @background_color = comment.user_initials_background_color
    @user_initials    = comment.user_initials
    @created_at       = moment(comment.created_at)

  render: ->

    """
    <div class="comment">
        <div class="left">
          <div class="avatar" style="background-color: #{@background_color}">
            <span class="initials">#{@user_initials}</span>
          </div>
        </div>
        <div class="info">
          <strong>#{@full_name}</strong> <span class="time">#{@created_at.format("HH:mm")}</span>
        </div>
        <div class="content">
          #{@comment}
        </div>
    </div>
    """

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

class @Feed
  constructor: (channel, channel_multiple, node, currentComments) ->
    @comments     = new CommentsQueue()
    @feed         = new ChannelObserver(@comments)
    @commentsFeed = new CommentsFeed(@comments, node, commentsCount: 40)

    @prerender(node, currentComments)
    @feed.subscribe(channel)
    @feed.subscribe_multiple(channel_multiple)

  run: ->
    @commentsFeed.run()

  prerender: (node, currentComments) ->
    node.append(new Comment(comment).render()) for comment in currentComments
