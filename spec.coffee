spec       = require "washington"
assert     = require "assert"
Mediador   = require "./mediador"

spec "Fires events added to it, chainable", ->

  # The flag should be true and provides verification that the listener
  # function was executed
  flag = false

  # The listener function that asserts that the argument is correct
  # and set the flag to true, verifying that it was executed
  datumAsserter = (datum)->
    assert.equal datum, "datum"
    flag = true

  # Define a function that inherits the "on" and "trigger" methods
  # from Mediador. Mediador is built to support this type of multiple
  # inheritance, the hypothesis being that almost any object will benefit
  # from being amplified with event support
  Heir = ->
  Heir.prototype.on      = Mediador.prototype.on
  Heir.prototype.trigger = Mediador.prototype.trigger

  # Lets get a new instance of the custom function
  heir = new Heir

  # Hook the listener on the "fire" event
  result = heir.on "fire", datumAsserter

  # Check that the return value of the "on" method is the emitter itself,
  # for chainability
  assert.equal result, heir

  # Trigger teh "fire" event with the argument
  result = heir.trigger "fire", ["datum"]

  # Check that "trigger" is chainable too
  assert.equal result, heir

  # Verify that the listener was in fact called
  assert.equal flag, true

spec "Removes the event when instructed", ->

  # The flag should be false and provides verification that the listener
  # function was not executed
  flag = false

  # The listener function that asserts that the argument is correct
  # and set the flag to true, verifying that it was executed
  datumAsserter = (datum)->
    assert.equal datum, "datum"
    flag = true

  # Define a function that inherits the "on", "off", and "trigger" methods
  # from Mediador. Mediador is built to support this type of multiple
  # inheritance, the hypothesis being that almost any object will benefit
  # from being amplified with event support
  Heir = ->
  Heir.prototype.off     = Mediador.prototype.off
  Heir.prototype.on      = Mediador.prototype.on
  Heir.prototype.trigger = Mediador.prototype.trigger

  # Lets get a new instance of the custom function
  heir = new Heir

  # Hook the listener on the "fire" event
  result = heir.on "fire", datumAsserter

  # Unhook the listener. Make sure that "off" is chainable
  result = heir.off 'fire', datumAsserter
  assert.equal result, heir

  # Trigger the event, that should result in nothing at all happening
  result = heir.trigger 'fire', ["datum"]

  # Verify that the listener was not executed
  assert.equal flag, false

spec "Binds a full event hash when instructed", ->

  # Flags for the two event in the eventHash
  actionFlag = false
  reactionFlag = false

  # The eventHash is just an object which properties' names will be used
  # to map the corresponding methods to the events of the emitter
  eventHash =
    action: (datum)->
      assert.equal datum, "actionDatum"
      actionFlag = true

    reaction: (datum)->
      assert.equal datum, "reactionDatum"
      reactionFlag = true

  # Define a function that inherits the "on", "off", and "trigger" methods
  # from Mediador. Mediador is built to support this type of multiple
  # inheritance, the hypothesis being that almost any object will benefit
  # from being amplified with event support
  Heir = ->
  Heir.prototype.off     = Mediador.prototype.off
  Heir.prototype.on      = Mediador.prototype.on
  Heir.prototype.trigger = Mediador.prototype.trigger

  # Lets get a new instance of the custom function
  heir = new Heir

  # Hook the full eventHash
  heir.on eventHash

  # Trigger the `action` event and the `reaction` event
  heir.trigger 'action', ["actionDatum"]
  heir.trigger 'reaction', ["reactionDatum"]

  # Verify that both event have been fired
  assert.equal actionFlag, true
  assert.equal reactionFlag, true

spec "Releases a full event hash when instructed", ->

  # Flags for the two event in the eventHash
  actionFlag = false
  reactionFlag = false

  # The eventHash is just an object which properties' names will be used
  # to map the corresponding methods to the events of the emitter
  eventHash =
    action: (datum)->
      assert.equal datum, "actionDatum"
      actionFlag = true

    reaction: (datum)->
      assert.equal datum, "reactionDatum"
      reactionFlag = true

  # Define a function that inherits the "on", "off", and "trigger" methods
  # from Mediador. Mediador is built to support this type of multiple
  # inheritance, the hypothesis being that almost any object will benefit
  # from being amplified with event support
  Heir = ->
  Heir.prototype.off     = Mediador.prototype.off
  Heir.prototype.on      = Mediador.prototype.on
  Heir.prototype.trigger = Mediador.prototype.trigger

  # Lets get a new instance of the custom function
  heir = new Heir

  # Hook the full eventHash
  heir.on eventHash

  # Unhook the full eventHash
  heir.off eventHash

  # Fire both events, should result in nothing happening
  heir.trigger 'action', ["actionDatum"]
  heir.trigger 'reaction', ["reactionDatum"]

  # Verify that the listeners were not fired
  assert.equal actionFlag, false
  assert.equal reactionFlag, false


spec.go()
