uuid      = require 'uuid'
io        = require 'socket.io-client'
co        = require 'co'

_dbDriver = null

useDatabase = (dbDriver) ->
  _dbDriver = dbDriver

init = (cb) ->
  console.log 'NewMeteor v0.0.0.1'

  lastServerStatus = {}

  socket = io.connect 'http://localhost:4000'
  socket.on 'serverStatus', (status) ->
    if status.restartedAt > lastServerStatus?.restartedAt
      console.log 'restarting...'
      location.reload()
    lastServerStatus = status

  socket.on 'document', (collectionName, document) ->
    _dbDriver.addDocument collectionName, document if _dbDriver

  window.NM =
    call: (method, args...) -> (cb) ->
      ticket = uuid.v4()
      socket.emit "method_#{method}", ticket, args
      socket.on "method_#{ticket}", (args) ->
        socket.removeListener "method_#{ticket}"
        cb null, args if cb
        console.warn "Method #{method} called without callback, result is", args unless cb
      undefined

    client: (genFn) ->
      co genFn.bind NM

  NM.client cb if cb

window.NM =
  init: init
  useDatabase: useDatabase
