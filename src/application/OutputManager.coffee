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
		nextFrame = nextFrame[0]
		# Convert the frame to a nice form for outputting to DOM
		htmlFrame = ((nextFrame.get(i, j).color.toHexString() for j in [0..nextFrame.width() - 1]) for i in [0..nextFrame.length() - 1])
		@nextFrame = htmlFrame

	onSendOutput: () ->
		if (@nextFrame?)
			@currentFrame = @nextFrame
			@nextFrame = null
		
		if (@currentFrame?)
			# Send frame to Arduino
			# console.log('Sending frame to Arduino over Serial.')

			# Send frame to browser
			# console.log('Sending frame to browser via socket.')
			@allWebSockets.emit('newFrame', @currentFrame)

