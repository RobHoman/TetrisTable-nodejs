##### IMPORTS #####
## 3rd Party ##
express = require('express')
socketIO = require('socket.io')
OutputManager = require('./application/OutputManager').OutputManager
TetrisEngine = require('./application/TetrisEngine').TetrisEngine
## 1st Party ##


##### Express HTTP Endpoint Initialization #####
app = express()

# For serving assets
app.use('/css', express.static('assets/css'))
app.use('/js', express.static('assets/js'))
app.use('/bower', express.static('bower_components/'))

app.use(express.bodyParser()) # Used to parse POST payload

##
# Bootstrap the controllers
##
require('./controllers/LEDRopeController')(app)
require('./controllers/LEDTableController')(app)

server = app.listen(3000, () ->
	console.log('Listening on port %d', server.address().port)
)

allWebSockets = socketIO(server)

##
# Define the socket. 
##
allWebSockets.on('connection', (socket) ->
	console.log('IO received connection.')
	# socket.on('input', (data) ->
	# 	console.log('Socket emitted input data:', data)
	# 	inputManager.emit('input', data)
	# )
)

##
# Initialize the OutputManager
##
outputManager = new OutputManager(allWebSockets)

tetrisEngine = new TetrisEngine(outputManager)

tetrisEngine.start()
