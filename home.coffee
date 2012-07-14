
{spawn} = require "child_process"


sispmctlOpts =
  1: 1
  2: 2
  3: 3
  4: 4
  all: "all"

createSispmctlFun = (operation) ->
  return (socketId, cb=->) ->
    if not sispmctlOpts[socketId]
      return cb new Error "Bad socket id #{ socketId }"
    console.info "Running sispmctl", [operation, socketId]
    sispmctl = spawn "sispmctl", [operation, socketId]
    sispmctl.on "exit", (status) ->
      cb status or null

powerOn = createSispmctlFun "-o"
powerOff = createSispmctlFun "-f"


writeWall = (msg, cb=->) ->
  wall = spawn "wall"
  wall.on "exit", (status) ->
    cb status or null
  wall.stdin.write msg
  wall.stdin.end()


module.exports =
  writeWall: writeWall
  powerOn: powerOn
  powerOff: powerOff

if require.main is module
  powerOn "all"
