# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Circle
  constructor: (containerSelector) ->
    @container = $(containerSelector)
    @chart = new Chartist.Pie(containerSelector)
    positive = parseInt(@container.data('positive'))
    negative = parseInt(@container.data('negative'))
    @update(positive, negative)

  update: (positive, negative) ->
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


pluralizePerson = (count) ->
  if count == 1
    'person'
  else
    'people'

channelBind = (userChannel, circle) ->
  userChannel.bind 'vote', (data) ->
    document.getElementById('votes-count').innerHTML = data['votes_count']
    document.getElementById('votes-noun').innerHTML = pluralizePerson(data['votes_count'])
    document.getElementById('positive-count').innerHTML = "#{data['positive_count']} #{pluralizePerson(data['positive_count'])}"
    document.getElementById('negative-count').innerHTML = "#{data['negative_count']} #{pluralizePerson(data['negative_count'])}"
    document.getElementById('left-progress-bar').style.width = data['positive_percent']
    document.getElementById('positive-percent').innerHTML = data['positive_percent']
    document.getElementById('right-progress-bar').style.width = data['negative_percent']
    document.getElementById('negative-percent').innerHTML = data['negative_percent']
    document.getElementById('neutral-count').innerHTML = data['neutral_count']
    document.getElementById('neutral-noun').innerHTML = pluralizePerson(data['neutral_count'])

    circle.update parseInt(data['positive_count']), parseInt(data['negative_count'])
  return

initialize = ->
  circle = new Circle('#circle-chart')
  pusher = new Pusher(pusher_key)
  userChannel = pusher.subscribe("dashboard_channel_#{debate_id}")
  channelBind(userChannel, circle)

$(document).ready -> initialize()
