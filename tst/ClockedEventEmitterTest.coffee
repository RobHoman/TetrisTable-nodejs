#### IMPORTS ####
### 3RD PARTY ###
AssertionError = require('chai').AssertionError
chai = require('chai')
chaiAsPromised = require("chai-as-promised")
chai.use(chaiAsPromised)
assert = require('chai').assert
expect = require('chai').expect
should = require('chai').should()
util = require('util')
Q = require('q')

### 1ST PARTY ###
ClockedEventEmitter = require('../src/ClockedEventEmitter').ClockedEventEmitter

describe('ClockedEventEmitter', () ->
	describe('#addListener(eventName, listener)', () ->
		it('Registers the given listener for the given event.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			callbackExecuted = false
			clockedEventEmitter.addListener(eventName, () ->
				callbackExecuted = true
			)
			clockedEventEmitter.emit(eventName)
			assert(callbackExecuted)
		)
	)
	describe('#on(eventName, listener)', () ->
		it('Registers the given listener for the given event.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			callbackExecuted = false
			clockedEventEmitter.on(eventName, () ->
				callbackExecuted = true
			)
			clockedEventEmitter.emit(eventName)
			assert(callbackExecuted)
		)
	)
	describe('#emit(eventName)', () ->
		it('Fires the callbacks of all listeners of this event.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			callbackExecuted = false
			clockedEventEmitter.on(eventName, () ->
				callbackExecuted = true
			)
			clockedEventEmitter.emit(eventName)
			assert(callbackExecuted)
		)
		it('Passes no event args to the listeners', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			argsReceived = false
			clockedEventEmitter.on(eventName, () ->
				argsReceived = arguments.length > 0
			)
			clockedEventEmitter.emit(eventName)

			assert(!argsReceived)
		)
	)
	describe('#emit(eventName, args...)', () ->
		it('Passes the event args to the listeners.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			argsReceived = false
			clockedEventEmitter.on(eventName, () ->
				argsReceived = arguments.length > 0
			)
			clockedEventEmitter.emit(eventName, "several", "extra", "eventargs")

			assert(argsReceived)
		)
	)
	describe('#emitOnInterval(msInterval, eventName)', () ->
		it('Emits the event with the given name on a regular interval.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			callbackExecutions = 0
			clockedEventEmitter.on(eventName, () ->
				callbackExecutions++
			)
			clockedEventEmitter.emitOnInterval(50, eventName)

			deferred = Q.defer()
			setTimeout(() ->
				clockedEventEmitter.clear(eventName)
				deferred.resolve(callbackExecutions)
			, 275)

			return deferred.promise.should.eventually.equal(5)
		)
		it('Passes no event args to the listeners', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'

			argsReceived = false
			clockedEventEmitter.on(eventName, () ->
				argsReceived = argsReceived or (arguments.length > 0)
			)
			clockedEventEmitter.emitOnInterval(50, eventName)

			deferred = Q.defer()
			setTimeout(() ->
				clockedEventEmitter.clear()
				deferred.resolve(argsReceived)
			, 275)

			return deferred.promise.should.not.eventually.become(true)
		)
		## TODO: In the future, I'd like to have this functionality update
		## the msInverval at which the event is emitted.
		it('Throws an exception when the given event name is already an active event.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'
			clockedEventEmitter.emitOnInterval(50, eventName)

			expect(() ->
				clockedEventEmitter.emitOnInterval(100, eventName)
			).to.throw(AssertionError)

			# Clean up
			clockedEventEmitter.clear()
		)
		## TODO: In the future, I'd like to have this functionality update
		## the msInverval at which the event is emitted and cause it to resume.
		it('Throws an exception when the given event name is already a paused event.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			msInterval = 50
			eventName = 'myEvent'
			clockedEventEmitter.emitOnInterval(msInterval, eventName)
			clockedEventEmitter.pause(eventName)

			expect(() ->
				clockedEventEmitter.emitOnInterval(msInterval, eventName)
			).to.throw(AssertionError)

			# Clean up
			clockedEventEmitter.clear()
		)
	)
	describe('#emitOnInterval(msInterval, eventName, args...)', () ->
		it('Passes the event args to the listeners.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			eventName = 'myEvent'

			argsReceived = true
			clockedEventEmitter.on(eventName, (args...) ->
				argsReceived = argsReceived and (args.length == 3)
			)
			clockedEventEmitter.emitOnInterval(50, eventName, "several", "extra", "eventargs")

			deferred = Q.defer()
			setTimeout(() ->
				clockedEventEmitter.clear()
				deferred.resolve(argsReceived)
			, 275)

			return deferred.promise.should.not.eventually.become(false)
		)
	)
	describe('#clear()', () ->
		it('Clears all events, including active and paused events.', () ->
			clockedEventEmitter = new ClockedEventEmitter()

			eventNames = [0..4].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)
			assert(clockedEventEmitter.isActive(eventName)) for eventName in eventNames

			# Pause a few events too
			clockedEventEmitter.pause(eventNames[0])
			clockedEventEmitter.pause(eventNames[2])

			clockedEventEmitter.clear()
			assert(!clockedEventEmitter.isRegistered(eventNames)) for eventName in eventNames
		)
	)
	describe('#clear(eventName)', () ->
		it('Clears an active event with the given event name.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			n = 3
			eventNames = [0..n].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)
			assert(clockedEventEmitter.isActive(eventName)) for eventName in eventNames

			# Clear the first event
			clockedEventEmitter.clear(eventNames[0])
			assert(!clockedEventEmitter.isRegistered(eventNames[0]))
			assert(clockedEventEmitter.isRegistered(eventNames[i])) for i in [1..n]

			# Clean up
			clockedEventEmitter.clear()
		)
		it('Clears a paused event with the given name.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			n = 3
			eventNames = [0..n].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)
			assert(clockedEventEmitter.isActive(eventName)) for eventName in eventNames

			# Pause, then clear the first event
			clockedEventEmitter.pause(eventNames[0])
			clockedEventEmitter.clear(eventNames[0])
			assert(!clockedEventEmitter.isRegistered(eventNames[0]))
			assert(clockedEventEmitter.isRegistered(eventNames[i])) for i in [1..n]

			# Clean up
			clockedEventEmitter.clear()
		)
		it('Throws an exception when no event with the given name exists.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			expect(() ->
				clockedEventEmitter.clear('eventThatDoesNotExist')
			).to.throw(AssertionError)
		)
	)
	describe('#pause()', () ->
		it('Pauses all active events.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			n = 3
			eventNames = [0..n].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)

			clockedEventEmitter.pause()
			assert(clockedEventEmitter.isPaused(eventName)) for eventName in eventNames

			# Clean up
			clockedEventEmitter.clear()
		)
	)
	describe('#pause(eventName)', () ->
		it('Pauses only the event with the given event name.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			n = 3
			eventNames = [0..n].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)

			# Pause just one event
			clockedEventEmitter.pause(eventNames[0])
			assert(clockedEventEmitter.isPaused(eventNames[0]))
			assert(clockedEventEmitter.isActive(eventNames[i])) for i in [1..n]

			# Clean up
			clockedEventEmitter.clear()
		)
		it('Throws an exception when no event with the given name exists.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			expect(() ->
				clockedEventEmitter.pause('eventThatDoesNotExist')
			).to.throw(AssertionError)
		)
		# TODO: Maybe this should just be a no-op
		it('Throws an exception when pausing an event that is already paused.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			pausedEventName = "eventThatIsPaused"
			clockedEventEmitter.emitOnInterval(200, pausedEventName)
			clockedEventEmitter.pause(pausedEventName)
			expect(() ->
				clockedEventEmitter.pause(pausedEventName)
			).to.throw(AssertionError)

			# Clean up
			clockedEventEmitter.clear()
		)
	)
	describe('#resume()', () ->
		it('Resumes all paused events.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			n = 3
			eventNames = [0..n].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)
			clockedEventEmitter.pause()
			assert(clockedEventEmitter.isPaused(eventName)) for eventName in eventNames

			clockedEventEmitter.resume()
			assert(clockedEventEmitter.isActive(eventName)) for eventName in eventNames

			# Clean up
			clockedEventEmitter.clear()
		)
	)
	describe('#resume(eventName)', () ->
		it('Resumes only the event with the given event name.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			n = 3
			eventNames = [0..n].map((i) -> 'myEvent' + i)

			eventNames.forEach((eventName) ->
				clockedEventEmitter.emitOnInterval(50, eventName)
			)
			clockedEventEmitter.pause()
			assert(clockedEventEmitter.isPaused(eventName)) for eventName in eventNames

			# Resume just one event
			clockedEventEmitter.resume(eventNames[0])
			assert(clockedEventEmitter.isActive(eventNames[0]))
			assert(clockedEventEmitter.isPaused(eventNames[i])) for i in [1..n]

			# Clean up
			clockedEventEmitter.clear()
		)
		it('Throws an exception when no event with the given name exists.', () ->
			clockedEventEmitter = new ClockedEventEmitter()
			expect(() =>
				clockedEventEmitter.resume('eventThatDoesNotExist')
			).to.throw(AssertionError)
		)
		# TODO: Maybe this should just be a no-op
		it('Throws an exception when resuming an event that is already active.', () ->
			clockedEventEmitter = new ClockedEventEmitter()

			activeEventName = "eventThatIsActive"
			clockedEventEmitter.emitOnInterval(200, activeEventName)
			expect(() =>
				clockedEventEmitter.resume(activeEventName)
			).to.throw(AssertionError)

			# Clean up
			clockedEventEmitter.clear()
		)
	)

	# Module-level tests
	it('Can emit several different events on interval at the same time.', () ->
		clockedEventEmitter = new ClockedEventEmitter()
		n = 3
		callbackExecutions = {}
		deferred = {}
		eventNames = [0..n - 1].map((i) -> "myEvent" + i)

		eventNames.forEach((eventName) =>
			callbackExecutions[eventName] = 0
			clockedEventEmitter.on(eventName, () ->
				callbackExecutions[eventName]++
			)
			clockedEventEmitter.emitOnInterval(50, eventName)

			deferred[eventName] = Q.defer()
		)

		setTimeout(() =>
			clockedEventEmitter.clear()
			eventNames.forEach((eventName) ->
				deferred[eventName].resolve(callbackExecutions[eventName])
			)
		, 275)

		return Q.all(
			deferred[eventName].promise.should.eventually.equal(5) for eventName in eventNames
		)
	)
	it('Stops emitting an event that has been cleared.', () ->
		clockedEventEmitter = new ClockedEventEmitter()
		n = 3

		eventToClear = "eventToClear"
		otherEvents = [0..n - 1].map((i) -> "myEvent" + i)
		allEvents = [eventToClear].concat(otherEvents)

		callbackExecutions = {}
		deferred = {}
		allEvents.forEach((eventName) =>
			callbackExecutions[eventName] = 0
			clockedEventEmitter.on(eventName, () ->
				callbackExecutions[eventName]++
			)
			clockedEventEmitter.emitOnInterval(50, eventName)

			deferred[eventName] = Q.defer()
		)

		# Clear just one event first
		setTimeout(() =>
			clockedEventEmitter.clear(eventToClear)
			deferred[eventToClear].resolve(callbackExecutions[eventToClear])
		, 275)

		# Then clear the others
		setTimeout(() ->
			otherEvents.forEach((eventName) ->
				clockedEventEmitter.clear(eventName)
				deferred[eventName].resolve(callbackExecutions[eventName])
			)
		, 525)

		return Q.all(
			deferred[eventToClear].promise.should.eventually.equal(5)
			deferred[eventName].promise.should.eventually.equal(10) for eventName in otherEvents
		)
	)
	it('Stops emitting an event that has become paused.', () ->
		clockedEventEmitter = new ClockedEventEmitter()
		eventName = "myEvent"

		callbackExecutions = 0
		clockedEventEmitter.on(eventName, () ->
			callbackExecutions++
		)

		clockedEventEmitter.emitOnInterval(50, eventName)

		setTimeout(() ->
			clockedEventEmitter.pause()
		, 125)

		deferred = Q.defer()
		setTimeout(() ->
			clockedEventEmitter.clear()
			deferred.resolve(callbackExecutions)
		, 500)

		return deferred.promise.should.eventually.equal(2)
	)
	it('Resumes emitting an event that has become resumed.', () ->
		clockedEventEmitter = new ClockedEventEmitter()
		eventName = "myEvent"

		callbackExecutions = 0
		clockedEventEmitter.on(eventName, () ->
			callbackExecutions++
		)

		clockedEventEmitter.emitOnInterval(50, eventName)

		setTimeout(() ->
			clockedEventEmitter.pause()
		, 125)

		deferred = Q.defer()
		setTimeout(() ->
			clockedEventEmitter.resume(eventName)
		, 250)

		setTimeout(() ->
			clockedEventEmitter.clear()
			deferred.resolve(callbackExecutions)
		, 375)

		return deferred.promise.should.eventually.equal(4)
	)
	it('Retains the event args as events are paused and resumed.', () ->
		clockedEventEmitter = new ClockedEventEmitter()
		eventName = "myEvent"
		eventArgs = ["some", "event", "args"]

		callbackExecutions = 0
		clockedEventEmitter.on(eventName, (args...) ->
			#assert.equal(args, eventArgs)
			callbackExecutions++
		)

		clockedEventEmitter.emitOnInterval(50, eventName, eventArgs[0], eventArgs[1], eventArgs[2])

		setTimeout(() ->
			clockedEventEmitter.pause()
		, 125)

		deferred = Q.defer()
		setTimeout(() ->
			clockedEventEmitter.resume(eventName)
		, 250)

		setTimeout(() ->
			clockedEventEmitter.clear()
			deferred.resolve(callbackExecutions)
		, 375)

		return deferred.promise.should.eventually.equal(4)

	)
)

