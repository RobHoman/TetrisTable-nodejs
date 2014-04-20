express = require('express')
SerialPort = require('serialport').SerialPort

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
app.use(express.static('assets'))
app.use(express.bodyParser()) # Used to parse POST payload

# For serving assets
app.use('/css', express.static(__dirname + '/css'))
app.use('/js', express.static(__dirname + '/js'))

app.get('/', (req, res) ->
	res.send('home')
)

app.get('/led', (req, res) ->
	context = { color : '#ffffff' }
	res.render('led-rope.jade', context)
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

server = app.listen(3000, () ->
	console.log('Listening on port %d', server.address().port)
)


