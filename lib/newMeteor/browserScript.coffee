sha1  = require 'sha1'
io    = require 'socket.io-client'
console.log 'NewMeteor v0.0.0.1', sha1 'NewMeteor v0.0.0.1'

lastServerStatus = {}

socket = io.connect 'http://localhost:4000'
socket.on 'serverStatus', (status) ->
  if status.restartedAt > lastServerStatus?.restartedAt
    console.log 'restarting...'
    location.reload()
  lastServerStatus = status
