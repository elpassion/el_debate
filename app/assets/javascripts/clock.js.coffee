isEven = (n) ->
  n % 2 == 0

tickingColan = (currentSeconds) ->
  if isEven(currentSeconds)
    ':'
  else
    ' '

updateClock = ->
  currentTime = new Date

  currentHours = currentTime.getHours()
  currentMinutes = currentTime.getMinutes()
  currentSeconds = currentTime.getSeconds()

  currentMinutes = (if currentMinutes < 10 then '0' else '') + currentMinutes
  currentSeconds = (if currentSeconds < 10 then '0' else '') + currentSeconds

  currentHours = if currentHours == 0 then '00' else currentHours

  currentTimeString = currentHours + tickingColan(currentSeconds) + currentMinutes

  $('#current-time').html currentTimeString
  return

initialize = ->
  setInterval 'updateClock()', 1000
  return

$(document).ready -> initialize()
