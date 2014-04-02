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

trello = Trello.create TRELLO_KEY, TRELLO_SECRET
github = Github.create GITHUB_USERNAME, GITHUB_TOKEN

github.listOrgEvents GITHUB_USERNAME, GITHUB_ORG
  # Initial content is the resource stream. Need to lift it
  .flatten()
  # Convert buffer to string
  .invoke 'toString'
  # Take all strings together
  .collect()
  # Join them into one
  .invoke 'join', ['']
  # Parse it as JSON
  .map JSON.parse
  # Take each event as its own data packet
  .flatten()
  # Should get them all in series
  .each (x) ->
    #console.log 'x', x
