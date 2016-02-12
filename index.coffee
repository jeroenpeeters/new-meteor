browserify  = require 'browserify'
coffeeify   = require 'coffeeify'
_           = require 'lodash'

bundle = browserify
  extensions: ['.coffee']

bundle.transform coffeeify,
  bare: false
  header: false

bundle.add "#{__dirname}/browserScript.coffee"

sendNewMeteorJS = (req, res) ->
  bundle.bundle (error, result) ->
    throw error if error?
    res.send result
    res.end()

module.exports =
  express: (req, res, next) ->
    switch req.url
      when '/newMeteor.js' then sendNewMeteorJS req, res
      else next()

  init: (server, methods = {}) ->
    serverStatus =
      restartedAt: new Date()
    io = require('socket.io') server, { serveClient: false }
    io.on 'connection', (socket) ->
      socket.emit 'serverStatus', serverStatus

      for methodName of methods
        do (methodName) ->
          socket.on "method_#{methodName}", (ticket, args) ->
            res = methods[methodName].apply @, args
            socket.emit "method_#{ticket}", res
