#### IMPORTS ####
### 3rd Party ###

### 1st Party ###

##
# Initialize this socket.
# @param io An instance of socket.io attached to an http server.
##

init = (io) ->
	io.on('connection', (socket) ->
		socket.on('led', (data) ->
			console.log(data)
		)
	)

##
# Expose the init method.
##
exports = module.exports = init
