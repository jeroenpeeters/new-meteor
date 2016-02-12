sha1    = require 'sha1'
io      = require 'socket.io-client'

console.log 'NewMeteor v0.0.0.1', sha1 'NewMeteor v0.0.0.1'

lastServerStatus = {}

socket = io.connect 'http://localhost:4000'
socket.on 'serverStatus', (status) ->
  if status.restartedAt > lastServerStatus?.restartedAt
    console.log 'restarting...'
    location.reload()
  lastServerStatus = status

window.NM =
  call: (method, args...) -> (cb) ->
    ticket = sha1 "#{new Date()}"
    socket.emit "method_#{method}", ticket, args
    socket.on "method_#{ticket}", (args) ->
      socket.removeListener "method_#{ticket}"
      cb args if cb
      console.warn "Method #{method} called without callback, result is", args unless cb
    undefined

  client: (genFn) ->
    run genFn.apply NM

run = (gen) ->
  #gen = genFn()

  next = (value) ->
    #if er then return gen.throw(er)
    continuable = gen.next(value)

    if continuable.done then return
    cbFn = continuable.value
    cbFn(next)
  next()
#
#
# async = (a,b) -> (cb) ->
#   setTimeout ->
#     console.log 'i'
#     cb a + b
#   , 2000
#
# f = (a,b)->
#   console.log 1
#   x = yield async a,b
#   console.log 2
#   console.log 'x',x
#
# console.log '--', run f 10, 5
