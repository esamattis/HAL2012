define ["moment"], (moment) ->
  fromNow: (stamp) ->
    return "null" if not stamp
    stamp = parseInt stamp, 10
    return moment.duration(Date.now() - stamp).humanize()
