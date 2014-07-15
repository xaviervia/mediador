var Mediador = require("mediador")

var YourClass = function () {}
YourClass.prototype.on      = Mediador.prototype.on
YourClass.prototype.off     = Mediador.prototype.off
YourClass.prototype.trigger = Mediador.prototype.trigger

var yourInstance = new YourClass()

yourInstance.on("completed", function () {
  console.log("The 'event' was successfully triggered and 'completed' too")
})

yourInstance.on("event", function (irrelevant, emitter) {
  emitter.trigger("completed")
})

yourInstance.trigger("event", ["something irrelevant"])
