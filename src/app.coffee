http = require "http"
express = require "express"
RED = require "node-red"
async = require "async"
{normalize} = require "path"

loadVideos = require "./videos"

videoPath = normalize(process.env.VIDEO_PATH || "#{__dirname}/../videos")

settings =
  flowFile: normalize("#{__dirname}/../flow.json")
  functionGlobalContext: {}
  httpAdminRoot: "/"
  httpNodeRoot: "/api"
  nodesDir: normalize("#{__dirname}/../nodes")
  userDir: normalize("#{__dirname}/../tmp")
  verbose: true

funcs =
  app: (cb) ->
    cb null, express()

  videos: (cb) ->
    loadVideos videoPath, cb

  settings: ["videos", (cb, {videos}) ->
    settings.functionGlobalContext.videos = videos
    cb null, settings
  ]

  server: ["app", "settings", (cb, {settings, app}) ->
    server = http.createServer app
    RED.init server, settings
    app.use settings.httpAdminRoot, RED.httpAdmin
    app.use settings.httpNodeRoot, RED.httpNode
    server.listen 8000, cb
  ]

  red: ["server", (cb) ->
    RED.start().done cb
  ]

async.auto funcs, (err) ->
  if err
    console.log err
    process.exit 1

  console.log "Listening on http://localhost:8000"
