##
# OutputManager is responsible for sending output buffers to the Arduino and
# for sending output JSON to the web socket.
##

#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
class exports.OutputManager
	@allWebSockets
	
	@currentFrame
	@nextFrame
	
	constructor: (@allWebSockets) ->
		

	setNextFrame: (nextFrame) ->
		@nextFrame = nextFrame

	onSendOutput: () ->
		if (@nextFrame?)
			@currentFrame = @nextFrame
			@nextFrame = null
		
		if (@currentFrame?)
			# Send frame to Arduino
			# console.log('Sending frame to Arduino over Serial.')

			# Send frame to browser
			console.log('Sending frame to browser via socket.')

