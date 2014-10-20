app = require('app')
BrowserWindow = require('browser-window')

process.on 'uncaughtException', (err) ->
  console.log(err)

app.on 'open-url', (event, url) =>
  event.preventDefault()
  console.log(url)


start = ->
  app.on 'finish-launching', ->
    window = new BrowserWindow(show: false)
    express = require('express')()
    express.use(require('express').static(__dirname+'/views'))
    port = 0
    server = express.listen port, ->
      port = server.address().port
      window.loadUrl("http://localhost:#{port}/index.html")
      window.show()

start()
