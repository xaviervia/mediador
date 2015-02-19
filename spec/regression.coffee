spec       = require "washington"
Mediador   = require "../mediador"



spec "Calls listeners subscribed to it. Chainable @regression", ->
  # given
  venue         = {}
  venue.on      = Mediador::on
  venue.emit    = Mediador::emit

  # given
  spy          = (arg)->
    spy.arg    = arg

  # when
  result = venue.on "fire", spy

  # then chainable
  throw Error "Should be chainable" unless result is venue

  # when
  result = venue.emit "fire", ["text"]

  # then
  spy.arg is "text"



spec "Removes listeners @regression", ->
  # given
  venue         = {}
  venue.on      = Mediador::on
  venue.off     = Mediador::off
  venue.emit    = Mediador::emit

  # given
  spy          = (arg)->
    spy.called = true

  # when
  venue.on "fire", spy
  result = venue.off "fire", spy

  # then chainable
  throw Error "Should be chainable" unless result is venue

  # when
  venue.emit "fire", ["text"]

  # then unhooked
  not spy.called



spec "Subscribes a listener set @regression", ->
  # given
  set =
    action: (arg)->
      set.action.arg      = arg
    reaction: (arg)->
      set.reaction.arg    = arg

  # given
  venue         = {}
  venue.on      = Mediador::on
  venue.off     = Mediador::off
  venue.emit    = Mediador::emit

  # when
  venue.on set
  venue.emit 'action', ["act"]
  venue.emit 'reaction', ["react"]

  # then
  set.action.arg is "act" and
  set.reaction.arg is "react"



spec "Unsubscribes a listener set @regression", ->
  # given
  set =
    action: ->
      set.action.called   = true
    reaction: ->
      set.reaction.called = true

  # given
  venue         = {}
  venue.on      = Mediador::on
  venue.off     = Mediador::off
  venue.emit    = Mediador::emit

  # when
  venue.on set
  venue.off set
  venue.emit 'action'
  venue.emit 'reaction'

  # then
  not set.action.called and not set.reaction.called



spec "Called listeners receive the venue as the last argument @regression", ->
  # given
  spy = ->
    spy.last = spy.last or []
    spy.last.push arguments[arguments.length - 1]

  # given
  venue         = {}
  venue.on      = Mediador::on
  venue.off     = Mediador::off
  venue.emit    = Mediador::emit

  # when
  venue.on 'event', spy
  venue.emit "event", ["lala"]
  venue.emit "event", []
  venue.emit "event", [2, 32, true]
  venue.emit "event"

  # then
  arg is venue for arg in spy.last



spec "Works even when no comprehensions are available @regression", ->
  # given
  hijacked = {}
  hijacked.forEach = Array::forEach
  hijacked.filter  = Array::filter
  hijacked.map     = Array::map
  Array::forEach   = null
  Array::filter    = null
  Array::map       = null

  # given
  venue           = {}
  venue.on        = Mediador::on
  venue.off       = Mediador::off
  venue.emit      = Mediador::emit

  # then
  listener = ->
  venue.on "event", listener
  venue.emit "event", ["argument"]
  venue.off "event", listener

  # then
  hash = event: ->
  venue.on hash
  venue.emit "event", ["argument"]
  venue.off hash

  # restore
  Array::forEach  = hijacked.forEach
  Array::filter   = hijacked.filter
  Array::map      = hijacked.map



spec "Allows setting 'this' with an argument @regression", ->
  # given
  scope    = {}
  venue = new Mediador
  venue.on "event", ->
      throw Error "Should be scope" unless @ is scope
      scope.callback = true
    , scope

  # when
  venue.emit "event"

  # then
  scope.callback



spec "Respects the original 'this' in listener sets @regression", ->
  # given
  hash            =
    event: ->
      hash.event.called = true
      throw Error "Should be hash" unless @ is hash

  # given
  venue           = new Mediador
  venue.on hash

  # when
  venue.emit "event"

  # then
  hash.event.called



spec "Doesn't hang if the listener does not exist @regression", ->
  # given
  venue = new Mediador
  set   =
    event: ->
  venue.on set

  # when
  venue.off "event", ->
