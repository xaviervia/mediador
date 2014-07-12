var Mediador = require("mediador")

var YourClass = function () {}
YourClass.prototype.on      = Mediador.prototype.on
YourClass.prototype.trigger = Mediador.prototype.trigger

var yourInstance = new YourClass()

yourInstance.on("event", function (you) {
  console.log(you + " already firing events!")
})

yourInstance.trigger("event", ["Me"])
