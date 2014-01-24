noflo = require("noflo")

class SplitObject extends noflo.Component

  description: "splits a single object into multiple IPs,
    wrapped with the key as the group"

  constructor: ->
    @inPorts =
      in: new noflo.Port
    @outPorts =
      out: new noflo.Port

    @inPorts.in.on "begingroup", (group) =>
      @outPorts.out.beginGroup(group)

    @inPorts.in.on "data", (data) =>
      for key, value of data
        @outPorts.out.beginGroup(key)
        @outPorts.out.send(value)
        @outPorts.out.endGroup()

    @inPorts.in.on "endgroup", (group) =>
      @outPorts.out.endGroup()

    @inPorts.in.on "disconnect", =>
      @outPorts.out.disconnect()

exports.getComponent = -> new SplitObject
