##### IMPORTS #####
## 3rd Party ##
express = require('express')
socketIO = require('socket.io')
EventEmitter = require('events').EventEmitter

## 1st Party ##
ClockedEventEmitter = require('./ClockedEventEmitter').ClockedEventEmitter
OutputManager = require('./application/OutputManager').OutputManager
TetrisEngine = require('./application/TetrisEngine').TetrisEngine

##
# Define the dimensions of the table
##
TABLE_LENGTH = 20
TABLE_WIDTH = 10

##### Express HTTP Endpoint Initialization #####
app = express()

# For serving assets
app.use('/css', express.static('assets/css'))
app.use('/js', express.static('assets/js'))
app.use('/images', express.static('assets/images')) # TODO: use a CDN for assets
app.use('/bower', express.static('bower_components/'))

app.use(express.bodyParser()) # Used to parse POST payload

##
# Bootstrap the controllers
##
require('./controllers/LEDTableController')(app, TABLE_LENGTH, TABLE_WIDTH)
require('./controllers/EmberController')(app)

server = app.listen(3000, () ->
	console.log('Listening on port %d', server.address().port)
)

allWebSockets = socketIO(server)

##
# Initialize the InputManager
##
inputEventEmitter = new EventEmitter()

##
# Define the socket. 
##
allWebSockets.on('connection', (socket) ->
	console.log('IO received connection.')
	socket.on('keypress', (data) ->
		inputEventEmitter.emit('keypress', data)
	)
)

##
# Initialize the OutputManager
##
FPS = 30 # Defines the frame rate of the output
outputManager = new OutputManager(allWebSockets)
outputEventBus = new ClockedEventEmitter()

outputEventBus.on('sendOutput', () =>
	# console.log('sendOutput event received...')
	outputManager.onSendOutput()
)

outputEventBus.emitOnInterval(1000 / FPS, 'sendOutput')

##
# Initialize the TetrisEngine
##
tetrisEngine = new TetrisEngine(inputEventEmitter, outputManager)

## TODO: Re-enable this. It is disabled while I work on integrating ember
# tetrisEngine.start()


