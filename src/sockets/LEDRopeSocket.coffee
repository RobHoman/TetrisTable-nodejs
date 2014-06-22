#### IMPORTS ####
### 3rd Party ###
serialport = require('serialport')
SerialPort = serialport.SerialPort

### 1st Party ###

##### Serial Port Initialization #####
serialPort = new SerialPort(
	'/dev/tty.usbmodem1421',
	{
		baudrate: 9600
		parser: serialport.parsers.readline('\n')
	},
	true,
	(error) ->
		console.log(error)
)

serialPort.on('open', () ->
	console.log('Serial Port Open')
	serialPort.on('data', (data) ->
		console.log('Data Received: ' + data) 
	)
)

handleLEDChange = (index, color) ->
	
	redString = color.substring(1, 3)
	greenString = color.substring(3, 5)
	blueString = color.substring(5, 7)

	indexByte = parseInt(index, 16)
	redByte = parseInt(redString, 16)
	blueByte = parseInt(blueString, 16)
	greenByte = parseInt(greenString, 16)

	console.log(indexByte)
	console.log(redByte)
	console.log(greenByte)
	console.log(blueByte)

	buffer = new Buffer([indexByte, redByte, greenByte, blueByte])
	console.log(buffer)
	serialPort.write(buffer)
	

##
# Initialize this socket.
# @param io An instance of socket.io attached to an http server.
##
init = (io) ->
	io.on('connection', (socket) ->
		socket.on('ledChange', (data) ->
			handleLEDChange(data.index, data.color)
		)
	)

##
# Expose the init method.
##
exports = module.exports = init
