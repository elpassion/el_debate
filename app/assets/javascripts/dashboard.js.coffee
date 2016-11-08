# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

pluralizePerson = (count) ->
  if count == 1
    'person'
  else
    'people'

class TooltipMessage
  constructor: (@firstNumber, @secondNumber) ->

  message: ->
    if firstNumber > secondNumber
      '+1'
    else
      '-1'

class Tooltip
  constructor: (@domNode, @TooltipMessage, @data, @count) ->

  open: ->
    $(@domNode).tooltip({content: (new @TooltipMessage(@data['positive_count'], @count)).message()});
    $(@domNode).tooltip("open");

  close: ->
    $(@domNode).tooltip("close");

  start: ->
    @open()
    setTimeout @close() 3000


channelBind = (userChannel) ->
  positiveCount = parseInt(document.getElementById('positive-count').innerHTML)
  negativeCount = parseInt(document.getElementById('negative-count').innerHTML)
  userChannel.bind 'vote', (data) ->
    unless data['positive_count'] is positiveCount then (new Tooltip('.left-tooltip', TooltipMessage, data, positiveCount)).start()
    unless data['negative_count'] is negativeCount then (new Tooltip('.right-tooltip', TooltipMessage, data, negativeCount)).start()
    document.getElementById('votes-count').innerHTML = data['votes_count']
    document.getElementById('votes-noun').innerHTML = pluralizePerson(data['votes_count'])
    document.getElementById('positive-count').innerHTML = data['positive_count']
    document.getElementById('positive-noun').innerHTML = pluralizePerson(data['positive_count'])
    document.getElementById('negative-count').innerHTML = data['negative_count']
    document.getElementById('negative-noun').innerHTML = pluralizePerson(data['negative_count'])
    document.getElementById('left-progress-bar').style.width = data['positive_percent']
    document.getElementById('positive-percent').innerHTML = data['positive_percent']
    document.getElementById('right-progress-bar').style.width = data['negative_percent']
    document.getElementById('negative-percent').innerHTML = data['negative_percent']
    document.getElementById('neutral-count').innerHTML = data['neutral_count']
    document.getElementById('neutral-noun').innerHTML = pluralizePerson(data['neutral_count'])
  return

initialize = ->
  pusher = new Pusher(pusher_key)
  userChannel = pusher.subscribe("dashboard_channel_#{debate_id}")
  channelBind(userChannel)

$(document).ready -> initialize()
