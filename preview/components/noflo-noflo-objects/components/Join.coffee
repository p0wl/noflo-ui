_ = require("underscore")
noflo = require("noflo")

class Join extends noflo.Component

  description: "Join all values of a passed packet together as a
  string with a predefined delimiter"

  constructor: ->
    @delimiter = ","

    @inPorts =
      in: new noflo.Port
      delimiter: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.delimiter.on "data", (@delimiter) =>

    @inPorts.in.on "begingroup", (group) =>
      @outPorts.out.beginGroup(group)

    @inPorts.in.on "data", (object) =>
      if _.isObject object
        @outPorts.out.send _.values(object).join(@delimiter)

    @inPorts.in.on "endgroup", (group) =>
      @outPorts.out.endGroup()

    @inPorts.in.on "disconnect", =>
      @outPorts.out.disconnect()

exports.getComponent = -> new Join
