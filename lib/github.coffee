_ = require 'highland'
utility = require './utility'

BASE = 'api.github.com'
HEADERS =
  'User-Agent': 'Pixbi'

# All methods returns a Highland stream
exports.create = (username, password) ->
  listOrgEvents: (username, org) ->
    utility.request "https://#{username}:#{password}@#{BASE}/users/#{username}/events/orgs/#{org}",
      headers: HEADERS
