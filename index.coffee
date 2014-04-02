_ = require 'highland'
Redis = require 'redis'
Github = require './lib/github'
Trello = require './lib/trello'

{
  TRELLO_KEY
  TRELLO_SECRET
  TRELLO_BOARD
  GITHUB_USERNAME
  GITHUB_TOKEN
  GITHUB_ORG
  REDIS_HOST
  REDIS_PORT
  REDIS_PASSWORD
} = process.env

# Set up connection to Redis
redis = Redis.createClient REDIS_PORT, REDIS_HOST
redis.auth REDIS_PASSWORD

# The main loop, which runs immediately
runLoop = ->
  github.listOrgEvents GITHUB_USERNAME, GITHUB_ORG
    # Initial content is the resource stream. Need to lift it
    .flatten()
    # Convert buffer to string
    .invoke 'toString'
    # Take all strings together
    .collect()
    # Join them into one
    .invoke 'join', ['']
    # Ignore empty strings when there is no valid JSON responses
    .compact()
    # Parse it as JSON
    .map JSON.parse
    # Take each event as its own data packet
    .flatten()

    # We only care about issue events
    .filter (evt) ->
      evt.type is 'IssuesEvent'

    # Filter all events already in the database
    .flatFilter (evt) ->
      done = false
      _ (push, next) ->
        return push(null, _.nil) if done
        redis.get evt.id, (err, res) ->
          done = true
          console.log 'filter', res?
          push null, not res?
          next()

    # Save the record by event IDs
    .flatMap (evt) ->
      done = false
      _ (push, next) ->
        return push(null, _.nil) if done
        redis.set evt.id, JSON.stringify(evt), (err, res) ->
          done = true
          push null, evt
          next()

    # Should get them all in series
    .toArray (x) ->
      console.log JSON.stringify x
      redis.end()

trello = Trello.create
  username: TRELLO_KEY
  password: TRELLO_SECRET
  runLoop: runLoop
github = Github.create
  username: GITHUB_USERNAME
  password: GITHUB_TOKEN
  runLoop: runLoop

# Start the loop
runLoop()
