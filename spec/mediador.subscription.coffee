spec    = require 'washington'

Subscription = require('../mediador').Subscription

spec "new: Takes the endpoint, callback and context as arguments", ->
  # given
  endpoint = {}
  callback = {}
  context  = {}

  # when
  subscription = new Subscription endpoint, callback, context

  # then
  subscription.endpoint is endpoint
  subscription.callback is callback
  subscription.context is context



spec "#match: Matches when the same endpoint and callback are sent", ->
  # given
  endpoint = {}
  callback = {}
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when / then
  subscription.match endpoint, callback



spec "#match: Doesn't match when endpoint is the same but callback not", ->
  # given
  endpoint = {}
  callback = {}
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when / then
  not subscription.match endpoint, {}



spec "#match: Doesn't match when callback is the same but endpoint not", ->
  # given
  endpoint = {}
  callback = {}
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when / then
  not subscription.match {}, callback



spec "#notify: Fires the callback when notified with the proper event", ->
  # given
  endpoint = 'name'
  callback = ->
    callback.called = true
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when
  subscription.notify 'name'

  # then
  callback.called



spec "#notify: Doesn't fire the callback when the event doesn't match", ->
  # given
  endpoint = 'name'
  callback = ->
    callback.called = true
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when
  subscription.notify 'mean'

  # then
  not callback.called



spec "#notify: Returns true when fired", ->
  # given
  endpoint = 'name'
  callback = ->
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when / then
  subscription.notify 'name'



spec "#notify: Returns false when not fired", ->
  # given
  endpoint = 'name'
  callback = ->
  context  = {}
  subscription = new Subscription endpoint, callback, context

  # when / then
  not subscription.notify 'mean'



spec "#notify: Sends the arguments to the callback when firing", ->
  # given
  callback = ->
    callback.called = arguments
  subscription = new Subscription 'name', callback, {}

  # when
  subscription.notify 'name', [1, 2, 'tre']

  # then
  callback.called[0] is 1 and
  callback.called[1] is 2 and
  callback.called[2] is 'tre'



spec "#notify: Uses the context as `this` for the callback", ->
  # given
  context = {}
  callback = ->
    callback.context = @
  subscription = new Subscription 'name', callback, context

  # when
  subscription.notify 'name'

  # then
  callback.context is context



spec "#notify: Sends the venue as the last argument to the callback", ->
  # given
  context = {}
  callback = ->
    callback.venue = arguments[arguments.length - 1]
  venue = {}
  subscription = new Subscription 'name', callback, context

  # when
  subscription.notify 'name', [], venue

  # then
  callback.venue is venue



spec "#notify: Doesn't fail there is venue but arguments are missing", ->
  # given
  context = {}
  callback = ->
    callback.venue = arguments[arguments.length - 1]
  venue = {}
  subscription = new Subscription 'name', callback, context

  # when
  subscription.notify 'name', venue

  # then
  callback.venue is venue
