

express = require "express"
_  = require "underscore"

home = require "./home"

config = require "./config"


app = express.createServer()


serveMain = (req, res, opts={}) ->
  res.send """
  <!doctype html>
  <html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>Home Hal</title>
  </head>
  <body>
    <a href="#{ config.mountPath }/power/on">Power on</a>
    <a href="#{ config.mountPath }/power/off">Power off</a>
    <a href="#{ config.mountPath }/kamino/up">Kamino up</a>
  </body>
  </html>
  """


app.get config.mountPath, serveMain

app.get config.mountPath + "/power/on", (args...) ->
  home.powerOn "all"
  serveMain args...

app.get config.mountPath + "/power/off", (args...) ->
  home.powerOff "all"
  serveMain args...


app.get "*", (req, res) ->
  res.send ":P", 401


app.listen config.port, ->
  console.info "Listening on #{ config.port }:#{ config.mountPath }"
