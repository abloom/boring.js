fs = require 'fs'

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
          readDir file, (err, results) ->
            videos[f] = results
            count--
            cb null, videos if !count
        else
          videos.push file
          count--
          cb null, videos if !count

    cb null, videos if !count

module.exports = (videoPath, done) ->
  console.log "Loading videos"
  readDir videoPath, (err, videos) ->
    done err if err

    console.log "Videos loaded: #{videos.length}"
    done err if err
    done null, videos || []
