#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
ClockedEventEmitter = require('../ClockedEventEmitter').ClockedEventEmitter
LED = require('../models/LED').LED
LEDTable = require('../models/LEDTable').LEDTable

ENGINE_HZ = 3 # Could vary this value over time as the game speeds up

## TODO: could all event bus logic can be surfaced one layer up to some kind of Application class?
class exports.TetrisEngine

	@outputManager
	@engineEventBus
	
	@currentI
	@currentJ

	constructor: (@outputManager, @length, @width) ->

		@currentI = 0
		@currentJ = 0

		@engineEventBus = new ClockedEventEmitter()
		@engineEventBus.on('clockTick', () =>
			# console.log('updateModels event received...')
			this.onUpdateModels()
		)

	start: () ->
		@engineEventBus.emitOnInterval(1000 / ENGINE_HZ, 'clockTick')

	onUpdateModels: () ->
		updatedModels = new LEDTable(@length, @width)
		updatedModels.set(@currentI, @currentJ, new LED(255, 0, 0))

		@outputManager.setNextFrame(updatedModels)

	up: () ->
		@currentI--
		this.normalize()
		this.onUpdateModels()
	down: () ->
		@currentI++
		this.normalize()
		this.onUpdateModels()
	left: () ->
		@currentJ--
		this.normalize()
		this.onUpdateModels()
	right: () ->
		@currentJ++
		this.normalize()
		this.onUpdateModels()
	normalize: () ->
		while (@currentI < 0)
			@currentI += @length
		while (@currentI >= @length)
			@currentI -= @length
		while (@currentJ < 0)
			@currentJ += @width
		while (@currentJ >= @width)
			@currentJ -= @width
