spec       = require "washington"
assert     = require "assert"
Mediador   = require "../mediador"


spec ".getSubscriptionClassFor: Return Subscription when null @registering", ->
  assert.equal Mediador.getSubscriptionClassFor(), Mediador.Subscription



spec ".getSubscriptionClassFor: Return corresponding object @registering", ->
  # given
  object = {}
  Class = ->
  Mediador.registerSubscriptionClassFor object, Class

  # when + then
  assert.equal Mediador.getSubscriptionClassFor(object), Class



spec ".registerSubscriptionClassFor: Map to provided object @registering", ->
  # given
  object = {}
  Class = ->
  Mediador.registerSubscriptionClassFor object, Class

  # when + then
  assert.equal Mediador.getSubscriptionClassFor(object), Class



spec ".registerSubscriptionClassFor: Replace default (undefined) when passing undefined @registering", ->
  # when
  Class = ->
  Mediador.registerSubscriptionClassFor undefined, Class

  # then
  assert.equal Mediador.getSubscriptionClassFor(), Class

  # rollback
  Mediador.registerSubscriptionClassFor undefined, Mediador.Subscription



spec ".createSubscriptionFor: Instantiate corresponding class passing args @registering", ->
  # given
  Class = (@endpoint, @callback, @context) ->
  object = {}
  Mediador.registerSubscriptionClassFor object, Class

  # when
  subscription = Mediador.createSubscriptionFor object, 'endpoint', 'callback', 'context'

  # then
  assert subscription instanceof Class
  assert.equal subscription.endpoint, 'endpoint'
  assert.equal subscription.callback, 'callback'
  assert.equal subscription.context, 'context'



spec "#registerSubscription: Registers the class for the current object @registering", ->
  # given
  Class = (@endpoint, @callback, @context) ->
  venue = new Mediador

  # when
  result = venue.registerSubscription Class

  # then
  assert.equal Mediador.getSubscriptionClassFor(venue), Class
  assert.equal result, venue



spec "#registerSubscription: Registers the class for the current prototype @registering", ->
  # given
  Class = (@endpoint, @callback, @context) ->
  Heir = ->
  Heir:: = Object.create Mediador::

  # when
  result = Heir::registerSubscription Class

  # then
  assert.equal Mediador.getSubscriptionClassFor(Heir::), Class
  assert.equal result, Heir::



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



spec "#on: Uses the Subscription class for this if available @newAPI", ->
  # given
  endpoint = name: 'event'
  callback = name: 'callback'
  context  = name: 'context'
  subscription = (@endpoint, @callback, @context) ->
  venue    = new Mediador
  Mediador.registerSubscriptionClassFor venue, subscription

  # when
  venue.on endpoint, callback, context

  # then
  assert venue.subscriptions[0] instanceof subscription
  assert.equal venue.subscriptions[0].endpoint, endpoint
  assert.equal venue.subscriptions[0].callback, callback
  assert.equal venue.subscriptions[0].context, context



spec "#on: Uses the Subscription class for prototype of this if available @newAPI", ->
  # given
  endpoint = name: 'event'
  callback = name: 'callback'
  context = name: 'context'
  subscription = (@endpoint, @callback, @context) ->

  Heir = ->
  Heir.prototype = Object.create(Mediador.prototype)
  venue    = new Heir()
  Mediador.registerSubscriptionClassFor Heir.prototype, subscription

  # when
  venue.on endpoint, callback, context

  # then
  assert venue.subscriptions[0] instanceof subscription
  assert.equal venue.subscriptions[0].endpoint, endpoint
  assert.equal venue.subscriptions[0].callback, callback
  assert.equal venue.subscriptions[0].context, context



spec "#on: Uses the default Subscription (undefined) class from Mediador @newAPI", ->
  # given
  endpoint = name: 'event'
  callback = name: 'callback'
  context  = name: 'context'
  venue    = new Mediador
  subscription = (@endpoint, @callback, @context) ->
  Mediador.registerSubscriptionClassFor undefined, subscription

  # when
  venue.on endpoint, callback, context

  # then
  assert venue.subscriptions[0] instanceof subscription
  assert.equal venue.subscriptions[0].endpoint, endpoint
  assert.equal venue.subscriptions[0].callback, callback
  assert.equal venue.subscriptions[0].context, context

  # restore
  Mediador.registerSubscriptionClassFor undefined, Mediador.Subscription



spec "#off: Removes a Subscription that matches the arguments @newAPI", ->
  # given
  Sub = (@endpoint, @callback, @context) ->
  Sub::match = -> true
  venue = new Mediador()
  venue.registerSubscription Sub
  venue.on "something", "not", "used"

  # when
  venue.off "won't", "be", "used"

  # then
  assert.equal venue.subscriptions.length, 0
    


spec "#off: Doesn't remove a Subscription that doesn't match @newAPI"

spec "#on: Creates using properties as events, methods as callback and @set as context @newAPI"

spec "#off: Removes using properties as event, methods as callback @set @newAPI"

spec "#emit: Notifies every subscription, passes the args and venue @newAPI"
