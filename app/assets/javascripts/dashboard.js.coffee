# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
selectors = 
  left:
    progress: '.js-left-progress'
    count: '.js-left-count'
    percentage: '.js-left-percentage'
  right:
    progress: '.js-right-progress'
    count: '.js-right-count'
    percentage: '.js-right-percentage'
  centerCircle: '.js-center-circle'
  centerCount: '.js-center-count'
  debateTopic: '.js-debate-topic'
  debateStatus: '.js-debate-status'
  votesCount: '.js-votes-count'
  nounCount: '.js-noun-count'
  comments: '.js-comments'

class Circle
  constructor: (containerSelector) ->
    @container = $(containerSelector)
    @chart = new Chartist.Pie(containerSelector)
    positive = parseInt(@container.data('positive'))
    negative = parseInt(@container.data('negative'))
    @update(positive, negative)

  subscribe: (channel) ->
    channel.bind('debate_changed', @onDebateChanged)
    channel.bind('debate_reset', @onDebateChanged)

  onDebateChanged: (data) =>
    debate = data.debate
    @update(parseInt(debate.positive_count), parseInt(debate.negative_count))

  update: (positive, negative) =>
    if positive + negative > 0
      order = [negative, positive]
      if window.leftSidePositive == "true" then order.reverse()

      @setPercentage.apply(this, order)
      @container.show()
      @chart.update(@series(), @options())
    else
      @container.hide()

  setPercentage: (positive, negative) ->
    @negative = Math.round((negative / (negative + positive)) * 100)
    if 0 < @negative < 10
      @negative = 10
    else if 90 < @negative < 100
      @negative = 90
    @positive = 100 - @negative

  calculateStartAngle: ->
    if @negative in [0, 100]
      0
    else
      start = Math.round((90 - ((@negative + 1) / 2) * 3.6) % 360)
      if start < 0 then 360 + start else start

  series: ->
    padSize = if @negative in [0, 100] then 0 else 1
    series: [padSize, @negative - padSize, padSize, @positive - padSize]

  options: ->
    donut: true
    showLabel: false
    donutWidth: 12
    total: 100
    startAngle: @calculateStartAngle()

class ProgressBar
  constructor: (selector) ->
    @node = $(selector)

  update: (percent) ->
    @node.css('width', percent)

class Pluralized
  pluralize: (count) ->
    if count == 1 then 'person' else 'people'

class VotesCount extends Pluralized
  constructor: (selector) ->
    @node = $(selector)

  update: (count) ->
    @node.text("#{count} #{@pluralize(count)}")

class MultilineVotesCount extends Pluralized
  constructor: (counterSelector, nounSelector) ->
    @counterNode = $(counterSelector)
    @nounNode    = $(nounSelector)

  update: (count) ->
    @counterNode.text(count)
    @nounNode.text(@pluralize(count))

class PositiveVotes
  constructor: ->
    @votesCount  = new VotesCount(positiveSelectors.count)
    @progressBar = new ProgressBar(positiveSelectors.progress)
    @percentage  = $(positiveSelectors.percentage)

  update: (debate) ->
    @votesCount.update(debate.positive_count)
    @progressBar.update(debate.positive_percent)
    @percentage.html(debate.positive_percent)

class NegativeVotes
  constructor: ->
    @votesCount  = new VotesCount(negativeSelectors.count)
    @progressBar = new ProgressBar(negativeSelectors.progress)
    @percentage  = $(negativeSelectors.percentage)

  update: (debate) ->
    @votesCount.update(debate.negative_count)
    @progressBar.update(debate.negative_percent)
    @percentage.html(debate.negative_percent)

class NeutralVotes
  constructor: ->
    @counter = new MultilineVotesCount(selectors.centerCount)

  update: (debate) ->
    @counter.update(debate.neutral_count)

class ValidVotes
  constructor: ->
    @counter = new MultilineVotesCount(selectors.votesCount, selectors.nounCount)

  update: (debate) ->
    @counter.update(debate.votes_count)

class Votes
  constructor: ->
    @negativeVotes   = new NegativeVotes()
    @positiveVotes   = new PositiveVotes()
    @neutralVotes    = new NeutralVotes()
    @validVotes      = new ValidVotes()

  update: (debate) =>
    @negativeVotes.update(debate)
    @positiveVotes.update(debate)
    @neutralVotes.update(debate)
    @validVotes.update(debate)

  subscribe: (channel) ->
    channel.bind 'debate_changed', (data) =>
      @update(data.debate)

class Debate
  subscribe: (channel) ->
    channel.bind 'debate_opened', =>
      $(selectors.debateStatus).text('')
      $(selectors.debateTopic)[0].className = 'debate-topic'
    channel.bind 'debate_closed', =>
      $(selectors.debateStatus).text('Debate is closed.')
      $(selectors.debateTopic)[0].className = 'closed-debate'

initialize = ->
  pusher      = new Pusher(pusherAppKey, { cluster: pusherAppCluster, encrypted: true })
  userChannel = pusher.subscribe("dashboard_channel_#{debateCode}")
  feed        = new Feed(userChannel, $(selectors.comments))

  window.leftSidePositive = $('.js-left-positive').attr('data-positive')
  window.positiveSelectors = if leftSidePositive == 'true' then selectors.left else selectors.right
  window.negativeSelectors = if leftSidePositive != 'true' then selectors.right else selectors.left

  component.subscribe(userChannel) for component in [
    (new Circle(selectors.centerCircle)),
    (new Votes()),
    (new Debate())
  ]

  feed.run()

$(document).ready -> initialize()