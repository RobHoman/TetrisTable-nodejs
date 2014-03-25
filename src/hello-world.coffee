express = require('express')
SerialPort = require('serialport').SerialPort

# Serial Port Initialization

serialPort = new SerialPort('/dev/ttyACM0', {
	baudrate: 9600
})

serialPort.on('open', () ->
	console.log('Serial Port Open')
	serialPort.on('data', (data) ->
		# console.log('Data Received: ' + data) 
	)
)

# Express HTTP Endpoint Initialization
app = express()

app.get('/led', (req, res) ->
	res.send('Hello World')
)

app.get('/led/on', (req, res) ->
	console.log('Trying to turn led on...')
	serialPort.write(new Buffer('2'))
	res.send('Trying to turn led on...')
)

app.get('/led/off', (req, res) ->
	console.log('Trying to turn led off...')
	serialPort.write(new Buffer('1'))
	res.send('Trying to turn led off...')
)

server = app.listen(3000, () ->
	console.log('Listening on port %d', server.address().port)
)


