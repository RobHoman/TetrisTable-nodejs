#### IMPORTS ####
### 3RD PARTY ###
assert = require('chai').assert
EventEmitter = require('events').EventEmitter

### 1ST PARTY ###


##
# Wrap the EventEmitter class in order to add pausing, and resuming.
# Add an API whereby events can be registered to be emitted at regular
# timed intervals.
##
class exports.ClockedEventEmitter

	##
	# The wrapped EventEmitter
	##
	@_eventEmitter

	##
	# A hashmap of objects for storing active events.
	# e.g.
	# {
	#	eventName: { msInterval: 100, args: [eventArgs], intervalId: {object Object} },
	#	anotherEventName: { msInterval: 200, args: [eventArgs], intervalId: {object Object} },
	# }
	##
	@_activeEvents

	##
	# A hashmap of objects for storing paused events.
	# e.g.
	# {
	#	eventName: { msInterval: 100, args: [eventArgs]},
	#	anotherEventName: { msInterval: 200, args: [eventArgs] },
	# }
	##
	@_pausedEvents

	constructor: () ->
		@_eventEmitter = new EventEmitter()
		@_activeEvents = {}
		@_pausedEvents = {}
	##
	# Register a listener for an event.
	# @param eventName The name of the event to listen for.
	# @param listener A callback to fire when the event
	# is emitted.
	##
	on: (eventName, listener) ->
		@_eventEmitter.on(eventName, listener)
	##
	# The addListener method is deprecated. Use 'on'
	# instead.
	##
	addListener: (eventName, listener) ->
		@on(eventName, listener)

	##
	# Emit an event just one time.
	# @param eventName The name of the event to emit.
	# @param args... An array of event args passed
	# as parameters to the listener.
	##
	emit: (eventName, args...) ->
		@_eventEmitter.emit([eventName].concat(args)...)

	##
	# Emit an event regularly on a timed interval.
	# @param msInterval The interval at which the event
	# should be emitted.
	# @param eventName The name of the event to emit.
	# @param args... An array of event args passed
	# as parameters to the listener.
	##
	emitOnInterval: (msInterval, eventName, args...) ->
		assert(!@isRegistered(eventName))
		@_activeEvents[eventName] = {
			msInterval: msInterval,
			args: args,
			intervalId: setInterval(
				# Call using all arguments except the first
				() => @emit([eventName].concat(args)...),
				msInterval
			)
		}
	##
	# Clear an event that is either paused or actively
	# emitting on an interval.
	# @param eventName The name of the event to clear. If no
	# event is specified, all events (both paused and active)
	# are cleared.
	##
	clear: (eventName) ->
		if(eventName?)
			assert(@isRegistered(eventName))

			if(@isActive(eventName))
				clearInterval(@_activeEvents[eventName].intervalId)
				delete @_activeEvents[eventName]
			else if(@isPaused(eventName))
				delete @_pausedEvents[eventName]

		else
			# clear all active and paused events
			clearInterval(activeEvent.intervalId) for eventName, activeEvent of @_activeEvents
			@_activeEvents = {}
			@_pausedEvents = {}
			

	##
	# Pause an event that is being emitted on an interval.
	# It can be resumed later.
	# @param eventName The name of the event to pause. If no
	# event is specified, pause all events emitting on
	# interval.
	##
	pause: (eventName) ->
		if(eventName?)
			assert.isDefined(@_activeEvents[eventName], "Can't pause an event that is not active.")
			@_pause(eventName)
		else
			@_pause(eventName) for eventName, activeEvent of @_activeEvents

	##
	# Private helper method for moving an event from active to paused.
	##
	_pause: (eventName) ->
		clearInterval(@_activeEvents[eventName].intervalId)
		@_pausedEvents[eventName] = {
			msInterval: @_activeEvents[eventName].msInterval,
			args: @_activeEvents[eventName].args
		}
		delete @_activeEvents[eventName]

	##
	# Resume emitting an event that is paused.
	# @param event The name of the event to resume. If no
	# event is specified, resume all paused events.
	##
	resume: (eventName) ->
		if(eventName?)
			assert.isDefined(@_pausedEvents[eventName], "Can't resume an event that is not paused.")
			@_resume(eventName)
		else
			@_resume(eventName) for eventName, pausedEvent of @_pausedEvents

	##
	# Private helper method for moving an event from paused to active.
	##
	_resume: (eventName) ->
		event = @_pausedEvents[eventName]
		delete @_pausedEvents[eventName]

		@emitOnInterval(event.msInterval, eventName, event.args)

	##
	# Returns the list of eventNames that this emitter
	# is actively emitting on interval.
	##
	getActiveEvents: () ->
		return eventName for eventName, activeEvent of @_activeEvents

	##
	# Returns true if there exists an active event with the
	# given name. Otherwise, it returns false.
	# @param eventName Event name to test.
	##
	isActive: (eventName) ->
		return @_activeEvents[eventName]?

	##
	# Returns the list of eventNames that are paused.
	##
	getPausedEvents: () ->
		return eventName for eventName, pausedEvent of @_pausedEvents

	##
	# Returns true if there exists a paused event with the
	# given name. Otherwise, it returns false.
	# @param eventName Event name to test.
	##
	isPaused: (eventName) ->
		return @_pausedEvents[eventName]?

	##
	# Returns true if the given event name is registered
	# as either an active or paused event.
	# @param eventName Event to test.
	##
	isRegistered: (eventName) ->
		return @isActive(eventName) or @isPaused(eventName)
