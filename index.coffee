_ = require 'highland'
Redis = require 'redis'
Github = require './lib/github'
Trello = require './lib/trello'
utility = require './lib/utility'

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
  ## Get a stream of events
  events = github.listOrgEvents GITHUB_USERNAME, GITHUB_ORG
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

    # Filter all events already in the database. We must do this filter step
    # explicitly rather than just allowing Redis to save to database regardless
    # record existence because we don't want to process records already in the
    # database
    .flatFilter (evt) ->
      utility.once (done) ->
        redis.get evt.id, (err, res) ->
          done err, not res?
    # Save the record by event IDs
    .flatMap (evt) ->
      utility.once (done) ->
        redis.set evt.id, JSON.stringify(evt), (err, res) ->
          done err, evt

  ## Process issue events
  events.fork()
    # We only care about issue events
    .filter (evt) ->
      evt.type is 'IssuesEvent'

    # Should get them all in series
    .toArray (x) ->
      console.log JSON.stringify x
      redis.end()


  ## TODO: Process other events by forking


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
