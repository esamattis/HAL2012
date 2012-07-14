
require.config({
  baseUrl: "/scripts",
  paths: {
    jquery: "vendor/jquery",
    sockjs: "vendor/sockjs",
    moment: "vendor/moment"
  }
});

require(["jquery", "sockjs", "moment", "app/helper"], function($, SockJS, moment, helper) {
  return $(function() {
    var sock;
    $("#up,#down").each(function() {
      var wrap;
      wrap = $(this);
      return wrap.text(helper.fromNow(wrap.text()));
    });
    sock = new SockJS("/halhome");
    sock.onopen = function() {
      return console.info("OPEN");
    };
    return sock.onmessage = function(e) {
      var body, count, effect, selector, stamp, _ref;
      console.info("GOT", e.data, e);
      _ref = JSON.parse(e.data);
      for (selector in _ref) {
        stamp = _ref[selector];
        $("#" + selector).text(helper.fromNow(stamp));
      }
      count = 20;
      body = $("body");
      return (effect = function() {
        body.toggleClass("hilight");
        if (count--) {
          return setTimeout(effect, 50);
        } else {
          return body.removeClass("hilight");
        }
      })();
    };
  });
});
