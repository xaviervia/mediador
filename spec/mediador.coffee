spec       = require "washington"
assert     = require "assert"
Mediador   = require "../mediador"


spec "on: Creates the Subscription with the arguments #new", ->
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


spec "on: Uses the Subscription class from the venue #new"

spec "on: Uses the default Subscription class from Mediador if nothing else found #new"

spec "off: Removes a Subscription that matches the arguments#new"

spec "on: Creates using properties as events, methods as callback and #set as context #new"

spec "off: Removes using properties as event, methods as callback #set #new"

spec "emit: Notifies every subscription, passes the args and venue #new"
