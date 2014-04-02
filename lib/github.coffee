_ = require 'highland'
utility = require './utility'

ORIGIN = 'api.github.com'
HEADERS =
  'User-Agent': 'Pixbi'

# How often should we poll?
exports.pollInterval = 60

# Request wrapper around all requests to capture header information
request = (url, options) ->
  utility.request url, options, (res) ->
    # Update poll interval based on what GitHub tells us
    # TODO: maybe we should simply restart the loop from here
    exports.pollInterval = res.headers['x-poll-interval']

# All methods returns a Highland stream
exports.create = (username, password) ->
  base = "https://#{username}:#{password}@#{ORIGIN}"

  listOrgEvents: (username, org) ->
    request "#{base}/users/#{username}/events/orgs/#{org}",
      headers: HEADERS
