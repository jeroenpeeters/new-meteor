browserify  = require 'browserify'
coffeeify   = require 'coffeeify'
_           = require 'lodash'

bundle = browserify
  extensions: ['.coffee']

bundle.transform coffeeify,
  bare: false
  header: false

bundle.add "#{__dirname}/drivers/minimongo.coffee"
bundle.add "#{__dirname}/browserScript.coffee"

sendNewMeteorJS = (req, res) ->
  bundle.bundle (error, result) ->
    throw error if error?
    res.send result
    res.end()

module.exports =
  # Middleware for express.io
  express: (req, res, next) ->
    switch req.url
      when '/newMeteor.js' then sendNewMeteorJS req, res
      else next()

  # Add a script to be served to the client
  addClientScript: (clientScript) ->
    bundle.add clientScript

  init: (server, methods = {}, collections, clientScripts = []) ->
    serverStatus =
      restartedAt: new Date()
    io = require('socket.io') server, { serveClient: false }
    io.on 'connection', (socket) ->
      socket.emit 'serverStatus', serverStatus
      socket.emit 'document', 'users', {name:'jeroen', lastname:'peeters'}
      # socket.emit 'document', 'users', {name:'piet', lastname:'hein'}

      for methodName of methods
        do (methodName) ->
          socket.on "method_#{methodName}", (ticket, args) ->
            res = methods[methodName].apply @, args
            socket.emit "method_#{ticket}", res
