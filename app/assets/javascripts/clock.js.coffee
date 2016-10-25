class TimeFormatter
  constructor: (@date) ->

  format: ->
    "#{@hours()}#{@colonTick()}#{@minutes()}"

  minutes: ->
    minutes = @date.getMinutes()
    (if minutes < 10 then '0' else '') + minutes

  hours: ->
    hours = @date.getHours()
    if hours >= 0 && hours < 10 then '0' + hours.toString() else hours

  colonTick: ->
    if @date.getSeconds() % 2 == 0 then ':' else ' '

class Clock
  constructor: (@domNode, @timeFormatter) ->

  currentTimeFormatted: =>
    (new @timeFormatter(new Date())).format()

  render: =>
    @domNode.innerHTML = @currentTimeFormatted()

  start: ->
    @render()
    setInterval @render, 1000

initialize = ->
  node = document.getElementById 'current-time'
  (new Clock(node, TimeFormatter)).start()
  return

$(document).ready -> initialize()


