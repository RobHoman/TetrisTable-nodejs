#### IMPORTS ####
### 3RD PARTY ###
chai = require('chai')
chaiAsPromised = require("chai-as-promised")
chai.use(chaiAsPromised)
assert = require('chai').assert
expect = require('chai').expect
should = require('chai').should()
Q = require('q')

### 1ST PARTY ###
ClockedEventEmitter = require('../src/ClockedEventEmitter').ClockedEventEmitter


describe('ClockedEventEmitter', () ->
	describe('#addListener(event, listener)', () ->
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
	describe('#on(event, listener)', () ->
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
	describe('#emit(event, listener)', () ->
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
	)
	describe('#emitOnInterval(event, listener)', () ->
		it('Fires the callbacks of its listeners repeatedly.', () ->
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
	)
	describe('#clear()', () ->
		it('Clears all events.', () ->
			n = 3
			eventNames = [1..n].map((i) -> "myEvent" + i)

			clockedEventEmitter = new ClockedEventEmitter()
			callbackExecutions = []
			deferred = []
			eventNames.forEach((eventName) ->
				callbackExecutions[eventName] = 0
				clockedEventEmitter.on(eventName, () ->
					callbackExecutions[eventName]++
				)
				clockedEventEmitter.emitOnInterval(50, eventName)

				deferred[eventName] = Q.defer()

				deferred[eventName].promise.should.eventually.equal(5)
			)
			
			setTimeout(() ->
				clockedEventEmitter.clear()
				eventNames.forEach((eventName) ->
					deferred[eventName].resolve(callbackExecutions[eventName])
				)
			, 275)

			return Q.all(deferred)
		)
	)
	describe('#clear(event)', () ->
		it('Clears all events.', () ->
			#n = 3
			#eventNames = [1..n].map((i) -> "myEvent" + i)

			#clockedEventEmitter = new ClockedEventEmitter()
			#callbackExecutions = []
			#deferred = []
			#eventNames.forEach((eventName) ->
			#	callbackExecutions[eventName] = 0
			#	clockedEventEmitter.on(eventName, () ->
			#		callbackExecutions[eventName]++
			#	)
			#	clockedEventEmitter.emitOnInterval(50, eventName)

			#	deferred[eventName] = Q.defer()

			#	setTimeout(() ->
			#		clockedEventEmitter.clear()
			#		deferred[eventName].resolve(callbackExecutions[eventName])
			#	, 275)
			#	deferred[eventName].promise.should.eventually.equal(5)
			#)

			#return Q.all(deferred)
		)
	)
)

