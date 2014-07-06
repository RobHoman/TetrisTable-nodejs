#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
config = require('../../config')
LED = require('../LED').LED
LEDTable = require('../LEDTable').LEDTable
IShape = require('./shape/IShape').IShape

TETRIS_LENGTH = config.tetris.TETRIS_LENGTH
TETRIS_WIDTH = config.tetris.TETRIS_WIDTH

##
# This class models a TetrisBoard by wrapping an LEDTable object.
##
class exports.TetrisBoard
	
	@ledTable
	@activeShape

	constructor: () ->
		@ledTable = new LEDTable(TETRIS_LENGTH, TETRIS_WIDTH)
		@activeShape = new IShape()
	

	advanceActiveShape: () ->
		if (@activeShape.collidesDown(this))
			# write the activeShape to the board and make a new one
			@activeShape.coordinates.map (coordinate) =>
				@ledTable.set(coordinate.i, coordinate.j, new LED(@activeShape.getColor()))

			@activeShape = new IShape()
		else
			@activeShape.moveDown()

	moveShapeDown: () ->
		if (@activeShape.collidesDown(this))
			
		else
			@activeShape.moveDown()

	moveShapeLeft: () ->
		if (!@activeShape.collidesLeft(this))
			@activeShape.moveLeft()

	moveShapeRight: () ->
		if (!@activeShape.collidesRight(this))
			@activeShape.moveRight()

	rotateShape: () ->
		@activeShape.rotate(this)

	##
	# Returns true if the square at this index is non-black.
	# Also returns true if either index is out of bounds on the 
	# right-hand side, left-hand side or the bottom side of the board.
	##
	isOccupied: (i, j) ->
		if (i >= @ledTable.length() or j < 0 or j >= @ledTable.width())
			return true
		else if (i < 0)
			return false

		blackLED = new LED(0, 0, 0)
		if (!@ledTable.get(i, j).equals(blackLED))
			return true

		return false

	isFull: (row) ->

	##
	# Copy the ledTable state. Then add the active shape to it.
	# Return the result.
	##
	getFrame: () ->
		frame = @ledTable.copy()
		
		for coordinate in @activeShape.coordinates
			i = coordinate.i
			j = coordinate.j
			if (!(i < 0 or i >= frame.length() or j < 0 or j >= frame.width()))
				frame.set(i, j, new LED(@activeShape.getColor()))

		# @activeShape.coordinates.map (coordinate) =>
		# 	frame.set(coordinate.i, coordinate.j, new LED(@activeShape.getColor()))

		return frame

