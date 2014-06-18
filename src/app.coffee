http = require "http"
express = require "express"
RED = require "node-red"
async = require "async"
{normalize} = require "path"
omx = require "omxdirector"

loadVideos = require "./videos"

videoPath = normalize(process.env.VIDEO_PATH || "#{__dirname}/../videos")

settings =
  flowFile: normalize("#{__dirname}/../flow.json")
  functionGlobalContext: {omx}
  httpAdminRoot: "/"
  httpNodeRoot: "/api"
  nodesDir: normalize("#{__dirname}/../nodes")
  userDir: normalize("#{__dirname}/../tmp")
  verbose: true

funcs =
  app: (cb) ->
    cb null, express()

  server: ["app", (cb, {app}) ->
    server = http.createServer app
    cb null, server
  ]

  red: ["server", (cb, {server}) ->
    RED.init server, settings
    cb null, RED
  ]

  videos: ["red", (cb) ->
    loadVideos videoPath, (err, videos) ->
      RED.settings.functionGlobalContext.videos = videos
      cb null, videos
  ]

  settings: ["app", "red", "server", (cb, {app, server}) ->
    app.use settings.httpAdminRoot, RED.httpAdmin
    app.use settings.httpNodeRoot, RED.httpNode
    server.listen 8000, cb
  ]

  start: ["red", (cb) ->
    RED.start().done cb
  ]

async.auto funcs, (err) ->
  if err
    console.log err
    process.exit 1

  console.log "Listening on http://localhost:8000"
