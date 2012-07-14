
fs = require "fs"

express = require "express"
stylus = require "stylus"
_  = require "underscore"
sockjs = require "sockjs"
wol = require "wake_on_lan"

home = require "./home"
config = require "./config"


process.stdout.write "STDOUT write test\n"
process.stderr.write "STDERR write test\n"

# fs.writeFile "/tmp/halhome.pid", process.pid
console.info "Starting #{ new Date } in  #{ process.cwd() }"
console.info "ENV", process.env


sock = sockjs.createServer()
app = express.createServer()

app.configure ->
  sock.installHandlers app, prefix: "/halhome"
  app.use stylus.middleware
    src: __dirname + "/styles"
    dest: __dirname + "/public"
    compile: (str, path) ->
      stylus(str)
      .set("filename", path)

  app.use express.static __dirname + "/public"
  app.set "view engine", "hbs"



connections = []
db =
  up: null
  down: null

sock.on "connection", (conn) ->
  console.info "Got sockjs connection"
  connections.push conn
  conn.on "close", ->
    connections.splice connections.indexOf(conn), 1

webHookRespond = (res) ->
  res.send "ok"
  data = JSON.stringify db
  for conn in connections
    conn.write data

app.get config.mountPath + "/webhook/up", (req, res) ->
  db.up = Date.now()
  db.down = null
  console.info "webhook up", db
  home.writeWall "kamino is up"
  webHookRespond res

app.get config.mountPath + "/webhook/down", (req, res) ->
  db.down = Date.now()
  db.up = null
  console.info "webhook down", db
  webHookRespond res


serveMain = (req, res, opts={}) ->
  res.render "main",
    layout: false
    mountPath: config.mountPath
    db: db
    title: _.last(req.path.split "/").toUpperCase()


app.get config.mountPath, serveMain

app.get config.mountPath + "/power/on", (req, res) ->
  home.powerOn "all"
  serveMain req, res

app.get config.mountPath + "/power/off", (req, res) ->
  home.powerOff "all"
  serveMain req, res

app.get config.mountPath + "/wake", (req, res) ->
  console.info "Waking up #{ config.mac }"
  wol.wake config.mac
  serveMain req, res


app.get "*", (req, res) ->
  res.send ":P", 401

app.listen config.port, ->
  console.info "Listening on #{ config.port }:#{ config.mountPath }"
