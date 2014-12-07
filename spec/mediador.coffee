spec       = require "washington"
assert     = require "assert"
Mediador   = require "../mediador"


spec ".getSubscriptionClassFor: Return Subscription when null @subscriptions", ->
  assert.equal Mediador.getSubscriptionClassFor(), Mediador.Subscription



spec ".getSubscriptionClassFor: Return corresponding object @subscriptions", ->
  # given
  object = {}
  Class = ->
  Mediador.registerSubscriptionClassFor object, Class

  # when + then
  assert.equal Mediador.getSubscriptionClassFor(object), Class



spec ".registerSubscriptionClassFor: Map to provided object @subscriptions", ->
  # given
  object = {}
  Class = ->
  Mediador.registerSubscriptionClassFor object, Class

  # when + then
  assert.equal Mediador.getSubscriptionClassFor(object), Class

  

spec ".registerSubscriptionClassFor: Replace default (null) when passing null @subscriptions"

spec ".createSubscriptionFor: Instantiate corresponding class passing args @subscriptions"

spec "#on: Creates the Subscription with the arguments @newAPI", ->
  # given
  endpoint = name: 'event'
  callback = name: 'callback'
  context  = name: 'context'
  subscription = (@endpoint, @callback, @context) ->
  venue    = new Mediador

  # when
  venue.on endpoint, callback, context, subscription

  # then
  assert venue.subscriptions[0] instanceof subscription
  assert.equal venue.subscriptions[0].endpoint, endpoint
  assert.equal venue.subscriptions[0].callback, callback
  assert.equal venue.subscriptions[0].context, context



spec "#on: Uses the Subscription class for this if available @newAPI"

spec "#on: Uses the Subscription class for prototype of this if available @newAPI"

spec "#on: Uses the default Subscription (null) class from Mediador @newAPI"

spec "#off: Removes a Subscription that matches the arguments @newAPI"

spec "#on: Creates using properties as events, methods as callback and @set as context @newAPI"

spec "#off: Removes using properties as event, methods as callback @set @newAPI"

spec "#emit: Notifies every subscription, passes the args and venue @newAPI"
