_ = require 'highland'
hyperquest = require 'hyperquest'

# Nice wrapper around hyperquest that returns a Highland stream
exports.request = (url, options) ->
  hasRun = false

  _ (push, next) ->
    if hasRun
      push null, _.nil
      return

    hyperquest url, options, (err, res) ->
      hasRun = true
      push null, _ res
      next()
