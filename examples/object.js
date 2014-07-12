var Mediador     = require("mediador")
var emitter      = {}

emitter.on       = Mediador.prototype.on
emitter.trigger  = Mediador.prototype.trigger

emitter.on("event", function (text) {
  console.log(text)
})

emitter.trigger("event", ["Hello World"])
