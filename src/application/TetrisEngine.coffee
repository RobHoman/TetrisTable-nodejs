#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
ClockedEventEmitter = require('../ClockedEventEmitter').ClockedEventEmitter
LED = require('../models/LED').LED
LEDTable = require('../models/LEDTable').LEDTable
TetrisBoard = require('../models/tetris/TetrisBoard').TetrisBoard

ENGINE_HZ = 2 # Could vary this value over time as the game speeds up

class exports.TetrisEngine

	@inputEventEmitter
	@outputManager
	@engineEventBus
	@tetrisBoard

	constructor: (@inputEventEmitter, @outputManager) ->
		@engineEventBus = new ClockedEventEmitter()
		@engineEventBus.on('clockTick', () =>
			this.onUpdateModels()
		)
		@tetrisBoard = new TetrisBoard()

		@inputEventEmitter.on('keypress', (key) =>
			if (key == 'up')
				@tetrisBoard.rotateShape()
			else if (key == 'right')
				@tetrisBoard.moveShapeRight()
			else if (key == 'down')
				@tetrisBoard.moveShapeDown()
			else if (key == 'left')
				@tetrisBoard.moveShapeLeft()

			@outputManager.setNextFrame(@tetrisBoard.getFrame())
		)

	start: () ->
		@engineEventBus.emitOnInterval(1000 / ENGINE_HZ, 'clockTick')

	onUpdateModels: () ->
		@tetrisBoard.advanceActiveShape()
		@outputManager.setNextFrame(@tetrisBoard.getFrame())

