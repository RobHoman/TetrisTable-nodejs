#### IMPORTS ####
### 3RD PARTY ###
assert = require('chai').assert
### 1ST PARTY ###
config = require('../../config')
Coordinate = require('../Coordinate').Coordinate
Color = require('../Color').Color
LED = require('../LED').LED
LEDTable = require('../LEDTable').LEDTable
IShape = require('./shape/IShape').IShape

TETRIS_LENGTH = config.tetris.TETRIS_LENGTH
TETRIS_WIDTH = config.tetris.TETRIS_WIDTH

SHAPE_STARTING_POSITION = new Coordinate(-1, Math.floor(TETRIS_WIDTH / 2) - 2)

##
# This class models a TetrisBoard by a 2D array of Color objects.
##
class exports.TetrisBoard
	
	@_colors
	@_activeShape
	
	##	
	# The coordinates of the upper left-hand corner of the activeShape
	##
	@_activeShapePosition

	constructor: () ->
		@_colors = new LEDTable(TETRIS_LENGTH, TETRIS_WIDTH)
		@_colors = [0..TETRIS_LENGTH - 1].map (i) ->
				[0..TETRIS_WIDTH - 1].map (j) ->
					new Color()
		@_activeShapePosition = SHAPE_STARTING_POSITION
	

	advanceActiveShape: () ->
		if !(@moveShapeDown())
			# Lock the active shape into the @_colors
			for coordinate in TetrisBoard._getTranslatedCoordinates(@_activeShape, @_activeShapePosition)
				@_colors[coordinate.i][coordinate.j] = @_activeShape.getColor().copy()
			@_activeShape = null
			@_activeShapePosition = null
			return false
		return true
		
	moveShapeDown: () ->
		if !(@isColliding(TetrisBoard._getTranslatedCoordinates(@_activeShape, @_activeShapePosition.below())))
			@_activeShapePosition = @_activeShapePosition.below()
			return true
		return false

	moveShapeLeft: () ->
		if !(@isColliding(TetrisBoard._getTranslatedCoordinates(@_activeShape, @_activeShapePosition.left())))
			@_activeShapePosition = @_activeShapePosition.left()
			return true
		return false

	moveShapeRight: () ->
		if !(@isColliding(TetrisBoard._getTranslatedCoordinates(@_activeShape, @_activeShapePosition.right())))
			@_activeShapePosition = @_activeShapePosition.right()
			return true
		return false

	rotateShape: () ->
		potentialShape = @_activeShape.copy()
		potentialShape.rotate()

		if (!@isColliding(TetrisBoard._getTranslatedCoordinates(potentialShape, @_activeShapePosition)))
			@_activeShape.rotate()
			return true
		return false

		
		

	##
	# Returns true if the square at this index is non-black.
	# Also returns true if any index is out of bounds on the 
	# right-hand side, left-hand side or bottom side of the board. Otherwise, it returns false.
	# @param i The row index
	# @param j The column index
	##
	isOccupied: (i, j) ->
		if (i >= this.length() or j < 0 or j >= this.width())
			return true
		else if (i < 0)
			return false

		black = new Color(0, 0, 0)
		if (!@_colors[i][j].equals(black))
			return true

		return false

	##
	# Returns true if any of the coordinates in the passed
	# array collide with occupied squares of this tetris board.
	# @coordinates An array of coordinate objects to check for collision
	##
	isColliding: (coordinates) ->
		for coordinate in coordinates
			if @isOccupied(coordinate.i, coordinate.j)
				return true
		return false

	##
	# Returns true if every square in the passed row is
	# occupied. Otherwise it returns false.
	# @row An integer index for a row. It should be that
	# 0 <= row < @length()
	##
	isFull: (row) ->
		if(row < 0 or row >= @length())
			return false
		for j in [0..@width() - 1]
			if !(@isOccupied(row, j))
				return false
		return true
	
	##
	# TODO: Test this method
	# Delete the passed row and slide all rows above
	# down one.
	##
	deleteRow: (row) ->
		if(row < 0 or row >= @length())
			return
		for i in [row..0]
			@_copyFromAbove(i)

	##
	# TODO: Test this method
	# Copy the row above this row into the row specified
	# here. If row is 0, put empty squares into this row.
	##
	_copyFromAbove: (row) ->
		if(row == 0)
			for j in [0..@width() - 1]
				@_colors[row][j] = new Color(0, 0, 0)

		else
			for j in [0..@width() - 1]
				@_colors[row][j] = @_colors[row - 1][j]

	##
	# Copy the ledTable state. Then add the active shape to it.
	# Return the result.
	##
	getFrame: () ->
		frame = LEDTable.from2DColorArray(@_colors)
		
		if @_activeShape?
			for coordinate in TetrisBoard._getTranslatedCoordinates(@_activeShape, @_activeShapePosition)
				i = coordinate.i
				j = coordinate.j
				if (!(i < 0 or i >= frame.length() or j < 0 or j >= frame.width()))
					frame.set(i, j, new LED(@_activeShape.getColor()))

		return frame

	##
	# Get the length of this tetris board.
	##
	length: () ->
		return @_colors.length

	##
	# Get the width of this tetris board.
	##
	width: () ->
		return @_colors[0].length

	getColor: (args...) ->
		i = j = null
		if(args.length == 1)
			assert.instanceOf(args[0], Coordinate, 'A single argument must be an instance of Coordinate.')
			i = args[0].i
			j = args[0].j
		else if(args.length == 2)
			i = args[0]
			j = args[1]
		else
			throw new ArgumentError('#get(args...) accepts only 1 or 2 arguments')
		return @_colors[i][j]

	setColor: (args...) ->
		i = j = color = null
		if(args.length == 2)
			assert.instanceOf(args[0], Coordinate, 'The first of two arguments must be an instance of Coordinate.')
			assert.instanceOf(args[1], Color, 'The second of two arguments must be an instance of Color.')
			i = args[0].i
			j = args[0].j
			color = args[1]
		else if(args.length == 3)
			assert.instanceOf(args[2], Color, 'The third of three arguments must be an instance of Color.')
			i = args[0]
			j = args[1]
			color = args[2]
		else
			throw new ArgumentError('#get(args...) accepts only 2 or 3 arguments')

		@_colors[i][j] = color
		return

	getActiveShape: () ->
		return @_activeShape

	setActiveShape: (shape) ->
		if(!@_activeShape?)
			@_activeShapePosition = SHAPE_STARTING_POSITION
		@_activeShape = shape

	@_getTranslatedCoordinates: (shape, upperLeftCoordinate) ->
		return shape.getCoordinates().map((coordinate) ->
			return new Coordinate(upperLeftCoordinate.i + coordinate.i, upperLeftCoordinate.j + coordinate.j)
		)

