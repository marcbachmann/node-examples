async = require('async')
noble = require('noble')
beanAPI = require('ble-bean')
connections = []

# You custom bean id. It will be listed when starting this script
currentBean = '992afa04118b4d60b4a9febbf2dd39d3'

exports.start = ->

  noble.on 'stateChange', (state) ->
    if state == 'poweredOn'
      noble.startScanning()
      console.log('Scanning for devices...')
    else
      noble.stopScanning()

  noble.on 'discover', (peripheral) ->
    uuid = peripheral.uuid
    console.log('Bean detected: %s', uuid)

    return unless peripheral.uuid == currentBean

    peripheral.connect (err) ->
      return err if err
      console.log('Connected Bean', peripheral.uuid)
      connections.push(peripheral)

      peripheral.discoverServices [], (err, services) ->
        return err if err
        for service in services
          if service.uuid == beanAPI.UUID
            new beanAPI.Bean(service).on 'ready', ->

              color = new Buffer([0,0,0])
              @setColor(color)

              @on 'accell', (x, y, z) =>
                console.log("received accell\tx: %s\ty: %s\tz: %s", x, y, z)

              setInterval =>
                @requestAccell()
              , 1000

              # .on 'accell', (x, y, z, valid)
              # .on 'temp', (celsius, valid)
              # .on 'serial', (data, valid)
              # .on 'raw', (data, length, valid, command)

              # @requestAccell(callback)
              # @requestTemp(callback)
              # @setColor(new Buffer([255,255,255]), callback(err))
              # @digitalWrite(13, 1)


triedToExit = false
exitHandler = (options, err) ->
  if connections.length && !triedToExit
    triedToExit = true
    async.each connections, (bean, done) ->
      console.log('\nDisconnecting from Bean %s', bean.uuid)
      bean.disconnect (err) ->
        console.log('Disconnected Bean %s', bean.uuid)
        done()
    , (err) ->
      process.exit(1 if err)

  else
    process.exit();

process.stdin.resume()
process.on('SIGINT', exitHandler.bind(null, {exit:true}))
