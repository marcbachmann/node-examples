_ = require('lodash')
SIPClient = require('sip-client')

opts = _.extend {}, require('./config'), debug: false

client = new SIPClient(opts)
uri =
  schema: 'sip'
  host: opts.host
  user: opts.user

headers =
  contact: "<sip:#{opts.host}:5060>"
  from:
    name: 'Marc Bachmann'
    uri: uri
  to:
    name: 'Marc Bachmann'
    uri: uri


message = client.message('register', host: opts.host, headers)
message.send()
message.on 'success', (msg) ->
  console.log(msg)
  client.on 'invite', (msg) ->
    from = client.sip.parseUri(msg.headers.from.uri)
    console.log(JSON.stringify(from))


message.on 'fail', (err) ->
  console.log(err)
