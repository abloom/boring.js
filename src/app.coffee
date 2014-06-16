http = require('http')
express = require("express")
RED = require("node-red")

# Create an Express app
app = express()

# Add a simple route for static content served from 'public'
#app.use "/", express.static("public")

# Create a server
server = http.createServer(app)

# Create the settings object
settings =
  flowFile: "#{__dirname}/../flow.json"
  flowFilePretty: true
  httpAdminRoot: "/red"
  httpNodeRoot: "/api"
  userDir: "#{__dirname}/../tmp"
  verbose: true
  functionGlobalContext:
    testing: 1

# Initialise the runtime with a server and settings
RED.init(server, settings)

# Serve the editor UI from /red
app.use settings.httpAdminRoot, RED.httpAdmin

# Serve the http nodes UI from /api
app.use settings.httpNodeRoot, RED.httpNode

server.listen 8000, ->
  # Start the runtime
  RED.start().done ->
    console.log "Listening on localhost:8000"
