_ = require 'highland'
hyperquest = require 'hyperquest'

# Nice wrapper around hyperquest that returns a Highland stream. It calls a
# callback with the resource as well if you want to extract the headers.
exports.request = (url, options, done) ->
  exports.once (done) ->
    hyperquest url, options, (err, res) ->
      done err, _ res

# Need to use a simple generator that runs once? Can't stand the syntax? Simply
# call this with a function that takes a callback that you call when you're
# done with the value to be passed downstream.
exports.once = (f) ->
  done = false

  _ (push, next) ->
    # If we're done, end the stream packet cycle
    return push(null, _.nil) if done

    # When the function is done, simply send result onward and go on the next
    # stream packet
    f (err, res) ->
      done = true
      push err, res
      next()
