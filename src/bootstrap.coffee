##### IMPORTS #####
## 3rd Party ##
express = require('express')
socketIO = require('socket.io')

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

io = socketIO(server)



##
# Bootstrap the socket listeners
##
require('./sockets/LEDRopeSocket')(io)
