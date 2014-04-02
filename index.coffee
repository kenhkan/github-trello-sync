Github = require './lib/github'
Trello = require './lib/trello'

{
  TRELLO_KEY
  TRELLO_SECRET
  TRELLO_BOARD
  GITHUB_USERNAME
  GITHUB_TOKEN
  GITHUB_ORG
} = process.env

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
    # Should get them all in series
    .toArray (x) ->
      console.log 'x', JSON.stringify(x)[0..200]

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
