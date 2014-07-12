var Mediador = require("mediador")

var YourClass = function () {}
YourClass.prototype.on      = Mediador.prototype.on
YourClass.prototype.off     = Mediador.prototype.off
YourClass.prototype.trigger = Mediador.prototype.trigger

var yourInstance = new YourClass()
var listener     = function (you) {
  console.log(you + " already firing events!")
}

yourInstance.on("event", listener)

yourInstance.trigger("event", ["Me"])

yourInstance.off("event", listener)
