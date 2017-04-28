# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class DebateStatus
  constructor: (selector) ->
    @element = $(selector)

  subscribe: (ticker) ->
    ticker.bind 'tick', @changeStatus

  changeStatus: (secondsLeft) =>
    if secondsLeft <= 0
      @element.text('closed')
    else
      @element.text('')

class Circle
  constructor: (containerSelector) ->
    @container = $(containerSelector)
    @chart = new Chartist.Pie(containerSelector)
    positive = parseInt(@container.data('positive'))
    negative = parseInt(@container.data('negative'))
    @update(positive, negative)

  subscribe: (channel) ->
    channel.bind 'debate_changed', (data) =>
      debate = data.debate
      @update(parseInt(debate.positive_count), parseInt(debate.negative_count))

  update: (positive, negative) =>
    if positive + negative > 0
      @setPercentage(positive, negative)
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
    donutWidth: 8
    total: 100
    startAngle: @calculateStartAngle()

class Tooltip
  constructor: (selector, @showTime) ->
    @node    = $(selector)
    @timeout = null

  update: (text) =>
    @show(text)

  show: (text) =>
    clearTimeout(@timeout)

    @node.find('.tooltip-text').text(text)
    @node.show()

    @timeout = setTimeout @hide, @showTime

  hide: =>
    @node.fadeOut()


class TimeLeft
  constructor: (@secondsLeft) ->
    minutesLeft = Math.floor(@secondsLeft / 60)

    @timeSplitted = [
      (if minutesLeft >= 60 then Math.floor(minutesLeft / 60) else 0), # hours
      (if minutesLeft >= 60 then minutesLeft % 60 else minutesLeft),   # minutes
      (@secondsLeft % 60)                                              # seconds
    ]

    if @timeSplitted[0] == 0
      @timeSplitted.shift()

  format: =>
    (('0' + num)[-2..] for num in @timeSplitted[0...2]).join @separator()

  separator: =>
    if @secondsLeft % 2 == 0 then ':' else ' '


class Countdown
  constructor: (selector) ->
    @node = $(selector)
    @closedAt = parseInt(@node.data('closed-at')) * 1000
    @interval = null
    @listeners = { 'tick' : [], 'finished' : [] } # event -> [function(data)]

  subscribe: (channel) ->
    channel.bind 'debate_changed', (data) =>
      @updateCosedAt(data.debate.closed_at)
      @run()

  bind: (event, fn) ->
    (@listeners[event] ||= []).push(fn)

  run: ->
    unless @interval?
      @interval = setInterval @update, 1000

  update: =>
    left = @secondsLeft()
    (listener(left) for listener in @listeners['tick'])
    if left <= 0
      clearInterval @interval
      @interval = null
      (listener(left) for listener in @listeners['finished']) if left <= 0

  updateCosedAt: (closedAt) =>
    @closedAt = closedAt * 1000

  secondsLeft: =>
    Math.round((@closedAt - Date.now()) / 1000)

class Clock
  constructor: (selector) ->
    @node = $(selector)

  subscribe: (ticker) ->
    ticker.bind 'tick', (secondsLeft) =>
      if secondsLeft > 0
        @node.text(new TimeLeft(secondsLeft).format())
      else
        @node.text('00:00')

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
    @votesCount  = new VotesCount('#positive-count')
    @progressBar = new ProgressBar('#left-progress-bar')
    @percentage  = $('#positive-percent')
    @tooltip     = new Tooltip('.left-tooltip', 3000)

  update: (debate, voteChange) ->
    @votesCount.update(debate.positive_count)
    @progressBar.update(debate.positive_percent)
    @percentage.html(debate.positive_percent)
    @tooltip.update(voteChange.positive) if voteChange? && voteChange.positive != 0

class NegativeVotes
  constructor: ->
    @votesCount  = new VotesCount('#negative-count')
    @progressBar = new ProgressBar('#right-progress-bar')
    @percentage  = $('#negative-percent')
    @tooltip     = new Tooltip('.right-tooltip', 3000)

  update: (debate, voteChange) ->
    @votesCount.update(debate.negative_count)
    @progressBar.update(debate.negative_percent)
    @percentage.html(debate.negative_percent)
    @tooltip.update(voteChange.negative) if voteChange? && voteChange.negative != 0

class NeutralVotes
  constructor: ->
    @counter = new MultilineVotesCount('#neutral-count', '#neutral-noun')

  update: (debate) ->
    @counter.update(debate.neutral_count)

class ValidVotes
  constructor: ->
    @counter = new MultilineVotesCount('#votes-count', '#noun-count')

  update: (debate) ->
    @counter.update(debate.votes_count)

class Votes
  constructor: ->
    @negativeVotes   = new NegativeVotes()
    @positiveVotes   = new PositiveVotes()
    @neutralVotes    = new NeutralVotes()
    @validVotes      = new ValidVotes()

  update: (debate, voteChange) =>
    @negativeVotes.update(debate, voteChange)
    @positiveVotes.update(debate, voteChange)
    @neutralVotes.update(debate)
    @validVotes.update(debate)

  subscribe: (channel) ->
    channel.bind 'debate_changed', (data) =>
      @update(data.debate, data.vote_change)

initialize = ->
  pusher      = new Pusher(pusher_key)
  userChannel = pusher.subscribe("dashboard_channel_#{debate_id}")
  countdown   = new Countdown('.time-box')
  slackFeed   = new SlackFeed(userChannel, $('#slack-comments .comments'))

  component.subscribe(userChannel) for component in [
    countdown,
    (new Circle('#circle-chart')),
    (new Votes())
  ]

  component.subscribe(countdown) for component in [
    (new Clock('.time-box .time-left')),
    (new DebateStatus('#debate-status')),
  ]

  countdown.run()
  slackFeed.run()

$(document).ready -> initialize()
