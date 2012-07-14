
define(["moment"], function(moment) {
  return {
    fromNow: function(stamp) {
      if (!stamp) {
        return "null";
      }
      stamp = parseInt(stamp, 10);
      return moment.duration(Date.now() - stamp).humanize();
    }
  };
});
