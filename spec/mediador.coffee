spec       = require "washington"
Mediador   = require "../mediador"


spec ".getSubscriptionClassFor: Return Subscription when null @registering", ->
  Mediador.getSubscriptionClassFor() is Mediador.Subscription



spec ".getSubscriptionClassFor: Return corresponding object @registering", ->
  # given
  object = {}
  Class = ->
  Mediador.registerSubscriptionClassFor object, Class

  # when + then
  Mediador.getSubscriptionClassFor(object) is Class



spec ".registerSubscriptionClassFor: Map to provided object @registering", ->
  # given
  object = {}
  Class = ->
  Mediador.registerSubscriptionClassFor object, Class

  # when + then
  Mediador.getSubscriptionClassFor(object) is Class



spec ".registerSubscriptionClassFor: Replace default (undefined) when passing undefined @registering", (check) ->
  # when
  Class = ->
  Mediador.registerSubscriptionClassFor undefined, Class

  # then
  check Mediador.getSubscriptionClassFor() is Class

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
  subscription instanceof Class and
  subscription.endpoint is 'endpoint' and
  subscription.callback is 'callback' and
  subscription.context is 'context'



spec "#registerSubscription: Registers the class for the current object @registering", ->
  # given
  Class = (@endpoint, @callback, @context) ->
  venue = new Mediador

  # when
  result = venue.registerSubscription Class

  # then
  Mediador.getSubscriptionClassFor(venue) is Class and
  result is venue



spec "#registerSubscription: Registers the class for the current prototype @registering", ->
  # given
  Class = (@endpoint, @callback, @context) ->
  Heir = ->
  Heir:: = Object.create Mediador::

  # when
  result = Heir::registerSubscription Class

  # then
  Mediador.getSubscriptionClassFor(Heir::) is Class and
  result is Heir::



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
  venue.subscriptions[0] instanceof subscription and
  venue.subscriptions[0].endpoint is endpoint and
  venue.subscriptions[0].callback is callback and
  venue.subscriptions[0].context is context



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
  venue.subscriptions[0] instanceof subscription and
  venue.subscriptions[0].endpoint is endpoint and
  venue.subscriptions[0].callback is callback and
  venue.subscriptions[0].context is context



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
  venue.subscriptions[0] instanceof subscription and
  venue.subscriptions[0].endpoint is endpoint and
  venue.subscriptions[0].callback is callback and
  venue.subscriptions[0].context is context



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
  venue.subscriptions[0] instanceof subscription and
  venue.subscriptions[0].endpoint is endpoint and
  venue.subscriptions[0].callback is callback and
  venue.subscriptions[0].context is context

  # restore
  Mediador.registerSubscriptionClassFor undefined, Mediador.Subscription



spec "#on: Sends the venue to the subscription constructor @newAPI", ->
  # given
  endpoint = name: 'event'
  callback = name: 'callback'
  context  = name: 'context'
  venue    = new Mediador
  subscription = (@endpoint, @callback, @context, @venue) ->
  Mediador.registerSubscriptionClassFor venue, subscription

  # when
  venue.on endpoint, callback, context

  # then
  venue.subscriptions[0].venue is venue



spec "#off: Removes a Subscription that matches the arguments @newAPI", ->
  # given
  Sub = (@endpoint, @callback, @context) ->
  Sub::match = ->
    @match.called = arguments
    true

  venue = new Mediador()
  venue.registerSubscription Sub
  venue.on "something", "not", "used"
  subscription = venue.subscriptions[0]

  # when
  venue.off "won't", "be", "used"

  # then
  venue.subscriptions.length is 0 and
  subscription.match.called[0] is "won't" and
  subscription.match.called[1] is "be" and
  subscription.match.called[2] is "used" and
  subscription.match.called[3] is venue



spec "#off: Doesn't remove a Subscription that doesn't match @newAPI", ->
  # given
  class Sub
    match: ->
      @match.called = arguments
      false

  venue = new Mediador
  venue.registerSubscription Sub
  venue.on "something", "not", "used"
  subscription = venue.subscriptions[0]

  # when
  venue.off "won't", "be", "used"

  # then
  venue.subscriptions.length is 1 and
  subscription.match.called[0] is "won't" and
  subscription.match.called[1] is "be" and
  subscription.match.called[2] is "used" and
  subscription.match.called[3] is venue



spec "#off: Removes the subscription only if of the provided type @newAPI", ->
  # given
  class Sub
    match: ->
      @match.called = arguments
      true

  class WrongType

  venue = new Mediador
  venue.registerSubscription Sub
  venue.on "something", "not", "used"
  subscription = venue.subscriptions[0]

  # when
  venue.off "shouldn't", "be", "used", WrongType

  # then
  venue.subscriptions.length is 1



spec "#off: Removes any amount of subscriptions @newAPI", ->
  # given
  class AlwaysTrue
    match: -> true
  class AlwaysFalse
    match: -> false
  venue = new Mediador
  venue.on 'first', 'subscription', '', AlwaysTrue
  venue.on 'second', 'subscription', '', AlwaysFalse
  venue.on 'third', 'subscription', '', AlwaysTrue

  # when
  venue.off 'irrelevant'

  # then
  venue.subscriptions.length is 1 and
  venue.subscriptions[0] instanceof AlwaysFalse



spec "#on: Creates using properties as events, methods as callback and @set as context @newAPI", ->
  # given
  Subscription = (@endpoint, @callback, @context) ->
  venue = new Mediador
  venue.registerSubscription Subscription
  subscriptionSet =
    event: ->
    property: 'not use'
    otherMethod: ->

  # when
  venue.on subscriptionSet

  # then
  return "Should have been 2 subscriptions" unless venue.subscriptions.length is 2
  eventSubscription = venue.subscriptions.filter((subscription) ->
    subscription.endpoint is 'event'
  )[0]
  otherSubscription = venue.subscriptions.filter((subscription) ->
    subscription.endpoint is 'otherMethod'
  )[0]

  eventSubscription.callback is subscriptionSet.event and
  eventSubscription.context is subscriptionSet and
  otherSubscription.callback is subscriptionSet.otherMethod and
  otherSubscription.context is subscriptionSet



spec "#off: Removes using properties as event, methods as callback @set @newAPI", ->
  # given
  subscriptionSet =
    event: ->
    method: ->
  class Sub
    constructor: (@endpoint, @callback, @context) ->
    match: (endpoint, callback, context) ->
      endpoint is @endpoint and callback is @callback and context is @context
  venue = new Mediador
  venue.on 'event', subscriptionSet.event, subscriptionSet, Sub
  venue.on 'method', subscriptionSet.method, subscriptionSet, Sub

  # when
  venue.off subscriptionSet

  # then
  venue.subscriptions.length is 0



spec "#emit: Notifies every subscription, passes the args and venue @newAPI", ->
  # given
  class Sub
    notify: ->
      @notify.called = arguments
  venue = new Mediador
  venue.on "not", "to", "be", Sub
  venue.on "more", "to", "do", Sub

  # when
  venue.emit 'arg', 'second arg', 'third arg'

  # then
  venue.subscriptions[0].notify.called[0] is 'arg' and
  venue.subscriptions[0].notify.called[1] is 'second arg' and
  venue.subscriptions[0].notify.called[2] is 'third arg' and
  venue.subscriptions[0].notify.called[3] is venue and
  venue.subscriptions[1].notify.called[0] is 'arg' and
  venue.subscriptions[1].notify.called[1] is 'second arg' and
  venue.subscriptions[1].notify.called[2] is 'third arg' and
  venue.subscriptions[1].notify.called[3] is venue
