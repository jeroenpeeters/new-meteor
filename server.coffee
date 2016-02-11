http      = require 'http'
express   = require 'express'
app       = express()
newMeteor = require './lib/newMeteor'

server = http.createServer app
newMeteor.init server

app.use newMeteor.express
app.use express.static 'public'

app.get '/hello', (req, res) ->
  res.send 'hello'

server.listen 4000
