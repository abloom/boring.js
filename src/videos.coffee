fs = require 'fs'
{reduce} = require 'underscore'

readDir = (path, videos, cb) ->
  if typeof videos == "function"
    cb = videos
    videos = {}

  fs.readdir path, (err, files) ->
    cb err if err

    count = files.length
    files.forEach (f) ->
      file = "#{path}/#{f}"
      fs.stat file, (err, stats) ->
        cb err if err

        if stats.isDirectory()
          readDir file, videos, (err, results) ->
            count--
            cb null, results if !count

        else
          parts = path.split("/")
          group = parts[parts.length - 1]

          videos[group] ||= []
          videos[group].push {path: file, name: f}

          count--
          cb null, videos if !count

    cb null, videos if !count

module.exports = (videoPath, done) ->
  console.log "Loading videos"
  readDir videoPath, (err, videos) ->
    done err if err

    count = reduce videos, ((acc, value, key) ->
      acc + value.length
    ), 0

    console.log "Videos loaded: #{count}"
    done err if err
    done null, videos
