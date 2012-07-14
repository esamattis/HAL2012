

require.config
  baseUrl : "/scripts"
  paths:
    jquery: "vendor/jquery"
    sockjs: "vendor/sockjs"
    moment: "vendor/moment"

require ["jquery", "sockjs", "moment", "app/helper"],
  ($, SockJS, moment, helper) -> $ ->

    $("#up,#down").each ->
      wrap = $ this
      wrap.text helper.fromNow wrap.text()

    sock = new SockJS "/halhome"
    sock.onopen = -> console.info "OPEN"

    sock.onmessage = (e) ->
      console.info "GOT", e.data, e
      for selector, stamp of JSON.parse e.data
        $("##{ selector }").text helper.fromNow stamp

      count = 20
      body = $ "body"
      do effect = ->
        body.toggleClass "hilight"
        if count--
          setTimeout effect, 50
        else
          body.removeClass "hilight"


