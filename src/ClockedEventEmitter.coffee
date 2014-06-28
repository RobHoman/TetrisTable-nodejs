##
# Wrap the event emitter class in order to add pausing, and resuming.
# Add an API whereby events can be registered to be emitted at regular
# timed intervals.
##

#### IMPORTS ####
### 3RD PARTY ###
EventEmitter = require('events').EventEmitter

### 1ST PARTY ###
class exports.ClockedEventEmitter
	@eventEmitter
	
	constructor: () ->
		@eventEmitter = new EventEmitter()

	##
	# Simply expose the 'on' method of EventEmitter
	##
	on: (event, listener) ->
		@eventEmitter.on(event, listener)

	##
	# Simply expose the 'emit' method of EventEmitter
	##
	emit: (event, args...) ->
		@eventEmitter.emit(event, args)

	##
	# Emit an event regularly on a timed interval.
	##
	emitOnInterval: (msInterval, event, args...) ->
		setInterval(
			() => this.emit(event, args),
			msInterval
		)
			
	pause: () ->
		throw new Exception("Implement this method.")
	resume: () ->
		throw new Exception("Implement this method.")
