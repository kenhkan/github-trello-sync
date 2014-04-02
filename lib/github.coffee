_ = require 'highland'
utility = require './utility'

ORIGIN = 'api.github.com'
HEADERS =
  'User-Agent': 'Pixbi'

# How often should we poll?
DEFAULT_POLL_INTERVAL = 60
# The E-Tag of the most recent request
etag = null

# All methods returns a Highland stream
exports.create = (params) ->
  { username, password, runLoop } = params

  base = "https://#{username}:#{password}@#{ORIGIN}"

  # Request wrapper around all requests to capture header information
  request = (url, options) ->
    # Add E-Tag if any to save some rate
    options.headers['if-none-match'] = etag if etag?

    utility.request url, options, (res) ->
      # Save the E-Tag to save some rate
      etag = res.headers['etag']
      # Run the loop in the future
      pollInterval = res.headers['x-poll-interval'] or DEFAULT_POLL_INTERVAL
      pollInterval = 5
      # Remember to convert to milliseconds
      pollInterval *= 1000
      # See you in the future
      #setTimeout runLoop, pollInterval

  listOrgEvents: (username, org) ->
    request "#{base}/users/#{username}/events/orgs/#{org}",
      headers: HEADERS
