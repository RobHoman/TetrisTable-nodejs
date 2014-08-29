#### IMPORTS ####
### 3RD PARTY ###
EventEmitter = require('events').EventEmitter

### 1ST PARTY ###

##
# Wrap the EventEmitter class in order to add pausing, and resuming.
# Add an API whereby events can be registered to be emitted at regular
# timed intervals.
##
class exports.ClockedEventEmitter
	@_eventEmitter

	##
	# An associative array to track active intervalIds
	# returned from setInterval calls. The key is the
	# event name; the value is the corresponding
	# intervalId.
	##
	@_intervalIds

	##
	# An array of objects for storing paused events.
	# e.g.
	# [
	#	{ event: 'eventName', msInterval: 100 },
	#	{ event: 'anotherEventName', msInterval: 200 },
	# ]
	##
	@_pausedEvents

	constructor: () ->
		@_eventEmitter = new EventEmitter()
		@_intervalIds = []
		@_pausedEvents = []
	##
	# Register a listener for an event.
	# @param event The name of the event to listen for.
	# @param listener A callback to fire when the event
	# is emitted.
	##
	on: (event, listener) ->
		@_eventEmitter.on(event, listener)
	##
	# The addListener method is deprecated. Use 'on'
	# instead.
	##
	addListener: (event, listener) ->
		@on(event, listener)

	##
	# Emit an event.
	# @param event The name of the event to emit.
	# @param args... An array of event args passed
	# as parameters to the listener.
	##
	emit: (event, args...) ->
		@_eventEmitter.emit(event, args)

	##
	# Emit an event regularly on a timed interval.
	##
	emitOnInterval: (msInterval, event, args...) ->
		@_intervalIds[event] = setInterval(
			() => @emit(event, args),
			msInterval
		)
	##
	# Clear an event that is being emitted on an interval.
	# @param event The name of the event to clear. If no
	# event is specified, all events emitting on interval
	# are cleared.
	##
	clear: (event) ->
		if(event?)
			clearInterval(@_intervalIds[event])
		else
			# clear all active intervalIds
			@_intervalIds.forEach((intervalId) ->
				clearInterval(intervalId)
			)
	##
	# Pause an event that is being emitted on an interval.
	# It can be resumed later.
	# @param event The name of the event to pause. If no
	# event is specified, pause all events emitting on
	# interval.
	##
	pause: (event) ->
		#if(event?)

	
	##
	# Resume emitting an event that is paused.
	# @param event The name of the event to resume. If no
	# event is specified, resume all paused events.
	##
	resume: (event) ->
		throw new Exception("Implement this method.")
