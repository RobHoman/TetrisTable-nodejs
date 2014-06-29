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
	
	@switch = false

	constructor: (@outputManager) ->
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

		updatedModels = new LEDTable(10, 20)

		if (@switch)
			updatedModels.set(5, 5, new LED(255, 0, 0)) 

		@switch = !@switch

		@eventBus.emit('endUpdateModels', updatedModels)


