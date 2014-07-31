#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
ClockedEventEmitter = require('../ClockedEventEmitter').ClockedEventEmitter
config = require('../config')
IShape = require('../models/tetris/shape/IShape').IShape
JShape = require('../models/tetris/shape/JShape').JShape
LShape = require('../models/tetris/shape/LShape').LShape
OShape = require('../models/tetris/shape/OShape').OShape
SShape = require('../models/tetris/shape/SShape').SShape
TShape = require('../models/tetris/shape/TShape').TShape
ZShape = require('../models/tetris/shape/ZShape').ZShape
LED = require('../models/LED').LED
LEDTable = require('../models/LEDTable').LEDTable
TetrisBoard = require('../models/tetris/TetrisBoard').TetrisBoard

ENGINE_HZ = 5 # Could vary this value over time as the game speeds up

class exports.TetrisEngine

	@inputEventEmitter
	@outputManager
	@engineEventBus
	@tetrisBoard
	@shapeCounter

	constructor: (@inputEventEmitter, @outputManager) ->
		@engineEventBus = new ClockedEventEmitter()
		@engineEventBus.on('clockTick', () =>
			this.onUpdateModels()
		)
		@tetrisBoard = new TetrisBoard()
		@tetrisBoard.setActiveShape(new IShape())

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
		@shapeCounter = 0

	start: () ->
		@engineEventBus.emitOnInterval(1000 / ENGINE_HZ, 'clockTick')

	onUpdateModels: () ->
		if(!@tetrisBoard.advanceActiveShape())
			# clear full rows
			for i in [config.tetris.TETRIS_LENGTH - 1..0]
				while(@tetrisBoard.isFull(i))
					@tetrisBoard.deleteRow(i)

			# give the board a new shape
			nextShapeType = getRandomInt(0, 7)
			shape = null
			if(nextShapeType == 0)
				shape = new IShape()
			else if(nextShapeType == 1)
				shape = new JShape()
			else if(nextShapeType == 2)
				shape = new LShape()
			else if(nextShapeType == 3)
				shape = new OShape()
			else if(nextShapeType == 4)
				shape = new SShape()
			else if(nextShapeType == 5)
				shape = new TShape()
			else if(nextShapeType == 6)
				shape = new ZShape()

			@tetrisBoard.setActiveShape(shape)

		@outputManager.setNextFrame(@tetrisBoard.getFrame())
## 
# Returns a random integer between min (included) and max (excluded).
##
getRandomInt = (min, max) ->
	  return Math.floor(Math.random() * (max - min)) + min

