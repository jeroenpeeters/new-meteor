http      = require 'http'
express   = require 'express'
app       = express()
newMeteor = require './lib/newMeteor'
server = http.createServer app

x = 0
methods =
  hello: (arg1, arg2) ->
    x = x + 1

newMeteor.init server, methods


app.use newMeteor.express
app.use express.static 'public'

app.get '/hello', (req, res) ->
  res.send 'hello'

server.listen 4000
