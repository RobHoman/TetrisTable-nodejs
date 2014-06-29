#### IMPORTS ####
### 3RD PARTY ###
ClockedEventEmitter = require('../ClockedEventEmitter').ClockedEventEmitter
LED = require('../models/LED').LED
LEDTable = require('../models/LEDTable').LEDTable

ENGINE_HZ = 3 # Could vary this value over time as the game speeds up
FPS = 30 # Defines the frame rate of the output

### 1ST PARTY ###
## TODO: could all event bus logic can be surfaced one layer up to some kind of Application class?
class exports.TetrisEngine
	
	@outputManager
	@eventBus
	
	@currentI
	@currentJ

	constructor: (@outputManager, @length, @width) ->

		@currentI = 0
		@currentJ = 0

		@eventBus = new ClockedEventEmitter()
		@eventBus.on('updateModels', () =>
			# console.log('updateModels event received...')
			this.onUpdateModels()
		)
		@eventBus.on('sendOutput', () =>
			# console.log('sendOutput event received...')
			@outputManager.onSendOutput()
		)
		@eventBus.on('endUpdateModels', (updatedModels) =>
			# console.log('endUpdateModels event received...')
			@outputManager.setNextFrame(updatedModels)
		)

	start: () ->
		@eventBus.emitOnInterval(1000 / ENGINE_HZ, 'updateModels')
		@eventBus.emitOnInterval(1000 / FPS, 'sendOutput')

	onUpdateModels: () ->
		updatedModels = new LEDTable(@length, @width)
		updatedModels.set(@currentI, @currentJ, new LED(255, 0, 0)) 

		@currentJ++
		if(@currentJ == @width)
			@currentJ = 0
			@currentI++
		if (@currentI == @length)
			@currentI = 0

		@eventBus.emit('endUpdateModels', updatedModels)


