// Mediador
// ========
//
// [ ![Codeship Status for xaviervia/mediador](https://codeship.io/projects/1b988be0-ebb2-0131-3c3b-4ebb653f9bc0/status)](https://codeship.io/projects/26547)
//
// EventEmitter look alike built as a mixin, with bulk listener setup support.
//
// Installation
// ------------
//
// ```
// npm install mediador --save
// ```
//
// Usage
// -----
//
// Mediador is a [**mixin**](https://en.wikipedia.org/wiki/Mixin). The idea is
// that you can add its methods to the prototypes or objects that you want to
// amplify with events.
//
// The events are stored in the `listeners` property within the emitter object.
// Bear this in mind in order to not override the property accidentally.
//
// You can find this examples in the [`examples`](examples) folder in this repo.
// You can run them without installing `mediador` by running `npm link` on
// the repo folder (may require sudo).
//
// ### Simple on/trigger
//
// Trigger will map each element in the array as an argument to the listener
// function.
//
// ```javascript
// var Mediador = require("mediador")
//
// var YourClass = function () {}
// YourClass.prototype.on      = Mediador.prototype.on
// YourClass.prototype.trigger = Mediador.prototype.trigger
//
// var yourInstance = new YourClass()
//
// yourInstance.on("event", function (you) {
//   console.log(you + " already firing events!")
// })
//
// yourInstance.trigger("event", ["Me"])
// ```
//
// ### Off with the listener
//
// ```javascript
// var Mediador = require("mediador")
//
// var YourClass = function () {}
// YourClass.prototype.on      = Mediador.prototype.on
// YourClass.prototype.off     = Mediador.prototype.off
// YourClass.prototype.trigger = Mediador.prototype.trigger
//
// var yourInstance = new YourClass()
// var listener     = function (you) {
//   console.log(you + " already firing events!")
// }
//
// yourInstance.on("event", listener)
//
// yourInstance.trigger("event", ["Me"])
//
// yourInstance.off("event", listener)
// ```
//
// ### You can add the methods directly in an object
//
// ```
// var Mediador     = require("mediador")
// var emitter      = {}
//
// emitter.on       = Mediator.prototype.on
// emitter.trigger  = Mediator.prototype.trigger
//
// emitter.on("event", function (text) {
//   console.log(text)
// })
//
// emitter.trigger("event", ["Hello World"])
// ```
//
// ### It also works in bulk
//
// ```javascript
// var Mediador = require("mediador")
//
// var YourClass = function () {}
// YourClass.prototype.on      = Mediador.prototype.on
// YourClass.prototype.off     = Mediador.prototype.off
// YourClass.prototype.trigger = Mediador.prototype.trigger
//
// var yourInstance = new YourClass()
//
// var eventHash = {
//   event: function () {
//     console.log("Called the event")
//   }
// }
//
// yourInstance.on(eventHash)
//
// yourInstance.trigger("event")
//
// yourInstance.off(eventHash)
// ```
//
// #### What is the `eventHash`?
//
// **Mediador** introduces the concept of an `eventHash`, that is just an
// object where every property method will be added as a listener in the
// emitter. For example, if the hash has a `read` method, its function will
// be added as a listener for the `read` event in the emitter.
//
// This is very useful both for adding events in bulk and for removing them.
// **Mediador** provides support for both operation in the `on` and `off`
// methods.
//
// ### Why does Mediador inserts the `listeners` property?
//
// This questions aims at the fact that once you add a listener with the `on`
// method, it will get added to the `listeners` property of the object, which
// will be created if not present and used if present
// (without checking for the `listeners` type, which may have been written by
// another function). This is of course a question about namespace pollution.
//
// The thing is, there are several strategies to avoid name collision within an
// object, and most of them involve encapsulating the library specific data
// in a private data object or using some kind of namespace (such a as
// naming the property `mediator_listeners` or `_listeners`).
// I don't favor this approach because:
//
// 1. Are you really planning on using several event libraries on the same
//    object?
// 2. Will you gladly use a library that extends your object blindfolded and
//    risk name collision anyways?
//
// In other words, I consider that using lightly a library _that extends your
// objects_ is a poor design choice. **Mediador** and other libraries of
// its kind should be considered part of your design and taken for what they
// are: tested, encapsulated and standardised methods to achieve certain
// behaviours that are useful only because they save you time.
//
// ### Why is there no `once` method?
//
// Remember:
//
// ```javascript
// // You can name an anonymous function to call it from within
// // You can totally do this:
// mediador.on("fire", function notAnonymousAnymore() {
//   mediador.off("fire", notAnonymousAnymore)
//   console.log("The 'fire' event was called")
// })
// ```
//
// > Corollary: EventEmitter's `once` method is not needed. Keep your APIs
// > simple (KYAS?)

"use strict"
var assert   = require("assert")
var spec     = require("washington")

var Mediador = function () {}

// Mediador.prototype.on
// ---------------------
//
// ### on( event, callback )
//
// Stores the `callback` function as a listener for the specified `event`.
// If the callback was already present, does nothing.
//
// Chainable.
//
// #### Arguments
//
// - `String` event
// - `Function` callback
//
// #### Returns
//
// - `Mediador` this
//
// ### on( eventHash )
//
// Binds all property methods of the `eventHash` as listeners in their
// respective events. For example, if `on` is called with the hash:
//
// ```javascript
// {
//   hear: function (something) { console.log(something); },
//   see: function (something) { console.log(something); },
// }
// ```
//
// the effect will be the same as if `on` had been called with `('hear',
// function (...) {...})` and `('see', function (...) {...})`.
//
// Chainable.
//
// #### Arguments
//
// - `Object` eventHash
//
// #### Returns
//
// - `Mediador` this
Mediador.prototype.on = function (event, callback) {

  //! If no callback, event hash assumed
  if (!callback) {

    //! For each key in the hash
    Object.keys(event).forEach((function (key) {

    //! If the property named with the key is a function
    if (event[key] instanceof Function)

      //! ...add the function as a listener to the event named after the key
      this.on(key, event[key]) }).bind(this))

  }

  //! If there is a callback this is setting a single event listener
  else {

    //! Create the event listeners hash if there wasn't one
    this.listeners = this.listeners || {}

    //! Create the listeners array for the event if there wasn't one
    this.listeners[event] = this.listeners[event] || []

    //! If the given callback was not present
    if (this.listeners[event].indexOf(callback) == -1)

      //! Store the callback
      this.listeners[event].push(callback)

  }

  //! Return this for chainability
  return this

}

// Mediador.prototype.trigger
// --------------------------
//
// ### trigger( event, args )
//
// Fires all the listener callbacks associated with the `event`. Chainable.
//
// #### Arguments
//
// - `String` event
// - `Array` args
//
// #### Returns
//
// - `Mediador` this
Mediador.prototype.trigger = function (event, args) {

  //! If there is a listeners hash
  if (this.listeners && this.listeners instanceof Object &&

      //! ...and there is an array for the event
      this.listeners[event] instanceof Array)

      //! Iterate the listeners
      this.listeners[event].forEach((function (listener) {

        //! ...and run 'em!
        listener.apply(null, args.concat([this])) }).bind(this))

  //! Return this for chainability
  return this

}

// Mediador.prototype.off
// ----------------------
//
// ### off( event, callback )
//
// Removes the `callback` function from the listener list to the `event`.
// Does nothing if the callback was not in the list.
//
// Chainable.
//
// #### Arguments
//
// - `String` event
// - `Function` callback
//
// #### Returns
//
// - `Mediador` this
//
// ### off( eventHash )
//
// Releases all property methods of the `eventHash` from their
// respective events. For example, if `off` is called with the hash:
//
// ```javascript
// {
//   hear: function (something) { console.log(something); },
//   see: function (something) { console.log(something); },
// }
// ```
//
// the effect will be the same as if `off` had been called with `('hear',
// function (...) {...})` and `('see', function (...) {...})`.
//
// Chainable.
//
// #### Arguments
//
// - `Object` eventHash
//
// #### Returns
//
// - `Mediador` this
Mediador.prototype.off = function (event, callback) {

  //! If there is no callback assumed to be an eventHash
  if (!callback) {

    //! For each key in the hash
    Object.keys(event).forEach((function (key) {

      //! If the property named with the key is a function
      if (event[key] instanceof Function)

        //! ...remove the function from the listeners' list of the event
        //! named after the key
        this.off(key, event[key]) }).bind(this))

  }

  //! If there is a callback this is removing a single event listener
  else

    //! You can't be to careful. Check everything is in place.
    if (this.listeners && this.listeners instanceof Object &&
        this.listeners[event] instanceof Array)

        //! Filter out the callback
        this.listeners[event] =
          this.listeners[event]
            .filter(function (listener) {
              return listener !== callback })

  //! Returns this for chainability
  return this

}

module.exports = Mediador

// Testing
// -------
//
// Tests require CoffeeScript. Install with `sudo npm install -g coffee-script`.
//
// Then clone the repo and run:
//
// ```
// > npm install
// > npm test
// ```
//
// License
// -------
//
// Copyright 2014 Xavier Via
//
// BSD 2 Clause license.
//
// See [LICENSE](LICENSE) attached.
