##### IMPORTS #####
## 3rd Party ##
express = require('express')
SerialPort = require('serialport').SerialPort
socketIO = require('socket.io')

## 1st Party ##
Color = require('./models/Color').Color
LED = require('./models/LED').LED
LEDRope = require('./models/LEDRope').LEDRope

##### Serial Port Initialization #####
serialPort = new SerialPort(
	'/dev/tty.usbmodem141411',
	{
		baudrate: 9600
	},
	true,
	(error) ->
		console.log(error)
)

serialPort.on('open', () ->
	console.log('Serial Port Open')
	serialPort.on('data', (data) ->
		# console.log('Data Received: ' + data) 
	)
)

##### Express HTTP Endpoint Initialization #####
app = express()

# For serving assets
app.use('/css', express.static('assets/css'))
app.use('/js', express.static('assets/js'))
app.use('/bower', express.static('bower_components/'))

app.use(express.bodyParser()) # Used to parse POST payload

server = app.listen(3000, () ->
	console.log('Listening on port %d', server.address().port)
)

io = socketIO(server)

io.on('connection', (socket) ->
	socket.emit('news', { hello: 'world' })
	socket.on('my other event', (data) ->
		console.log(data)
	)
)

app.get('/', (req, res) ->
	led = new LED(new Color({
		red: 50,
		green: 50,
		blue: 50,
	}))
	res.send(led.toJSON())
)

app.get('/led', (req, res) ->
	led = new LED(new Color({
		red: 50,
		green: 50,
		blue: 50,
	}))

	context = {
		led: led,
	}

	res.render('led.jade', context)
)

app.post('/led', (req, res) ->
	console.log(req.body)
	color = req.body.color
	
	redString = color.substring(1, 3)
	blueString = color.substring(3, 5)
	greenString = color.substring(5, 7)

	console.log(redString)
	console.log(blueString)
	console.log(greenString)

	redByte = parseInt(redString, 16)
	blueByte = parseInt(blueString, 16)
	greenByte = parseInt(greenString, 16)

	serialPort.write(new Buffer([redByte, greenByte, blueByte]))

	context = { color : color }
	res.render('led-rope.jade', context)
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

app.get('/leds', (req, res) ->
	ledRope = new LEDRope(9)

	context = {
		ledRope: ledRope,
	}

	res.render('led-rope.jade', context)
)




