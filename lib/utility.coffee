_ = require 'highland'
hyperquest = require 'hyperquest'

# Nice wrapper around hyperquest that returns a Highland stream. It calls a
# callback with the resource as well if you want to extract the headers.
exports.request = (url, options, done) ->
  hasRun = false

  _ (push, next) ->
    # Stop and end the stream if it has already run
    if hasRun
      push null, _.nil
      return

    hyperquest url, options, (err, res) ->
      # Run this only once
      hasRun = true
      # Pass to caller
      done res
      # Pass onward in stream
      push null, _ res
      # Need to complete the stream cycle
      next()
