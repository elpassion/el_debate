# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

pluralizePerson = (count) ->
  if count == 1
    'person'
  else
    'people'

channelBind = (userChannel) ->
  userChannel.bind 'vote', (data) ->
    document.getElementById('votes-count').innerHTML = data['votes_count']
    document.getElementById('votes-noun').innerHTML = pluralizePerson(data['votes_count'])
    document.getElementById('positive-count').innerHTML = data['positive_count']
    document.getElementById('negative-count').innerHTML = data['negative_count']
    document.getElementById('left-progress-bar').style.width = data['positive_percent']
    document.getElementById('positive-percent').innerHTML = data['positive_percent']
    document.getElementById('right-progress-bar').style.width = data['negative_percent']
    document.getElementById('negative-percent').innerHTML = data['negative_percent']
    document.getElementById('neutral-count').innerHTML = data['neutral_count']
    document.getElementById('neutral-noun').innerHTML = pluralizePerson(data['neutral_count'])
  return

initialize = ->
  pusher = new Pusher(pusher_key);
  userChannel = pusher.subscribe("dashboard_channel_#{debate_id}");
  channelBind(userChannel)

$(document).ready -> initialize()
