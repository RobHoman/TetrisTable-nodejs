#### IMPORTS ####
### 3RD PARTY ###
assert = require('chai').assert
expect = require('chai').expect

### 1ST PARTY ###
config = require('../../../src/config')
Color = require('../../../src/models/Color').Color
Coordinate = require('../../../src/models/Coordinate').Coordinate
IShape = require('../../../src/models/tetris/shape/IShape').IShape
LED = require('../../../src/models/LED').LED
LEDTable = require('../../../src/models/LEDTable').LEDTable
TetrisBoard = require('../../../src/models/tetris/TetrisBoard').TetrisBoard

describe('TetrisBoard', () ->
	describe('#constructor()', () ->
		it('Initializes a completely empty board.', () ->
			tetrisBoard = new TetrisBoard()
			assert(!tetrisBoard.isOccupied(i, j)) for j in [0..tetrisBoard.width() - 1] for i in [0..tetrisBoard.length() - 1]
		)
	)
	describe('#getActiveShape()', () ->
		it('Returns the active shape.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			assert.equal(shape, tetrisBoard.getActiveShape())
		)
	)
	describe('#setActiveShape(shape)', () ->
		it('Replaces the current active Shape with the passed in Shape.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			assert.equal(shape, tetrisBoard.getActiveShape())
		)
	)
	describe('#advanceActiveShape()', () ->
		it('Moves the activeShape down one, provided it doesn\'t collide with occupied squares.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedPosition = activeShapePosition.below()
			tetrisBoard.advanceActiveShape()
			assert(expectedPosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Locks the activeShape into the board when moving it down would otherwise cause it to collide.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 1, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			tetrisBoard.advanceActiveShape()
			assert.isNull(tetrisBoard.getActiveShape())
			assert.isNull(tetrisBoard._activeShapePosition)
			assert(tetrisBoard.getColor(config.tetris.TETRIS_LENGTH - 1, 0).equals(shape.getColor()))
			assert(tetrisBoard.getColor(config.tetris.TETRIS_LENGTH - 1, 1).equals(shape.getColor()))
			assert(tetrisBoard.getColor(config.tetris.TETRIS_LENGTH - 1, 2).equals(shape.getColor()))
			assert(tetrisBoard.getColor(config.tetris.TETRIS_LENGTH - 1, 3).equals(shape.getColor()))
		)
		it('Returns true when it successfully advances the active shape.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert.strictEqual(tetrisBoard.advanceActiveShape(), true)
		)
		it('Returns false when it does not successfully advance the active shape.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 1, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert.strictEqual(tetrisBoard.advanceActiveShape(), false)
		)
	)
	describe('#moveShapeDown()', () ->
		tetrisBoard = null
		beforeEach(() ->
			tetrisBoard = new TetrisBoard()
			tetrisBoard.setActiveShape(new IShape())
		)
		it('Moves the activeShape down one, provided it doesn\'t collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedPosition = activeShapePosition.below()
			tetrisBoard.moveShapeDown()
			assert(expectedPosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Does not move the activeShape down one if it would collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			# fill in a square beneath the active shape
			tetrisBoard.setColor(activeShapePosition.below().right(), new Color(255, 255, 255))
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedShapePosition = activeShapePosition
			tetrisBoard.moveShapeDown()
			assert(expectedShapePosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Does not move the activeShape down one if it would collide with the bottom.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 1, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedShapePosition = activeShapePosition
			tetrisBoard.moveShapeDown()
			assert(expectedShapePosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Returns true when the move is successful.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert(tetrisBoard.moveShapeDown())
		)
		it('Returns false when the move fails.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 1, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert(!tetrisBoard.moveShapeDown())
		)
	)
	describe('#moveShapeLeft()', () ->
		tetrisBoard = null
		beforeEach(() ->
			tetrisBoard = new TetrisBoard()
			tetrisBoard.setActiveShape(new IShape())
		)
		it('Moves the activeShape left one, provided it doesn\'t collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 1)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedPosition = activeShapePosition.left()
			tetrisBoard.moveShapeLeft()
			assert(expectedPosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Does not move the activeShape left one if it would collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 1)
			# fill in a square left of the active shape
			tetrisBoard.setColor(activeShapePosition.left(), new Color(255, 255, 255))
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedShapePosition = activeShapePosition
			tetrisBoard.moveShapeLeft()
			assert(expectedShapePosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Does not move the activeShape left one if it would collide with the left side.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedShapePosition = activeShapePosition
			tetrisBoard.moveShapeLeft()
			assert(expectedShapePosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Returns true when the move is successful.', () ->
			activeShapePosition = new Coordinate(0, 1)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert(tetrisBoard.moveShapeLeft())
		)
		it('Returns false when the move fails.', () ->
			activeShapePosition = new Coordinate(0, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert(!tetrisBoard.moveShapeLeft())
		)
	)
	describe('#moveShapeRight()', () ->
		tetrisBoard = null
		beforeEach(() ->
			tetrisBoard = new TetrisBoard()
			tetrisBoard.setActiveShape(new IShape())
		)
		it('Moves the activeShape right one, provided it doesn\'t collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, config.tetris.TETRIS_WIDTH - 5)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedPosition = activeShapePosition.right()
			tetrisBoard.moveShapeRight()
			assert(expectedPosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Does not move the activeShape right one if it would collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, config.tetris.TETRIS_WIDTH - 5)
			# fill in a square right of the active shape
			tetrisBoard.setColor(activeShapePosition.right(), new Color(255, 255, 255))
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedShapePosition = activeShapePosition
			tetrisBoard.moveShapeRight()
			assert(expectedShapePosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Does not move the activeShape right one if it would collide with the right side.', () ->
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, config.tetris.TETRIS_WIDTH - 4)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedShapePosition = activeShapePosition
			tetrisBoard.moveShapeRight()
			assert(expectedShapePosition.equals(tetrisBoard._activeShapePosition))
		)
		it('Returns true when the move is successful.', () ->
			activeShapePosition = new Coordinate(0, config.tetris.TETRIS_WIDTH - 5)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert(tetrisBoard.moveShapeRight())
		)
		it('Returns false when the move fails.', () ->
			activeShapePosition = new Coordinate(0, config.tetris.TETRIS_WIDTH - 4)
			tetrisBoard._activeShapePosition = activeShapePosition
			assert(!tetrisBoard.moveShapeRight())
		)
	)
	describe('#rotateShape()', () ->
		tetrisBoard = shape = null
		beforeEach(() ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
		)
		it('Rotate the activeShape clockwise, provided that rotating won\'t cause it to collide with occupied sqaures.', () ->
			activeShapePosition = new Coordinate(0, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			oldFrame = tetrisBoard.getFrame()
			tetrisBoard.rotateShape()
			frame = tetrisBoard.getFrame()
			assert(frame.get(0, 2).getColor().equals(shape.getColor()))
			assert(frame.get(1, 2).getColor().equals(shape.getColor()))
			assert(frame.get(2, 2).getColor().equals(shape.getColor()))
			assert(frame.get(3, 2).getColor().equals(shape.getColor()))
		)
		it('Does not rotate the active shape if it would collide with occupied squares.', () ->
			activeShapePosition = new Coordinate(0, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			# Occupy a square to prevent rotation
			tetrisBoard.setColor(activeShapePosition.below().right().right(), new Color(1, 1, 1))
			expectedFrame = tetrisBoard.getFrame()
			tetrisBoard.rotateShape()
			actualFrame = tetrisBoard.getFrame()
			assert.deepEqual(actualFrame, expectedFrame)
		)
		it('Does not rotate the active shape if it would collide with the bottom.', () ->
			# Put it near the bottom to prevent rotation 
			activeShapePosition = new Coordinate(config.tetris.TETRIS_LENGTH - 2, 0)
			tetrisBoard._activeShapePosition = activeShapePosition
			expectedFrame = tetrisBoard.getFrame()
			tetrisBoard.rotateShape()
			actualFrame = tetrisBoard.getFrame()
			assert.deepEqual(actualFrame, expectedFrame)
		)
	)
	describe('#isOccupied(i, j)', () ->
		it('Returns true if the i,jth square is completely black.', () ->
			tetrisBoard = new TetrisBoard()
			tetrisBoard.setColor(0, 0, new Color(0, 0, 0))
			assert(!tetrisBoard.isOccupied(0, 0))
		)
		it('Returns false when the i,jth square is non-black.', () ->
			tetrisBoard = new TetrisBoard()
			tetrisBoard.setColor(0, 0, new Color(5, 5, 5))
			assert(tetrisBoard.isOccupied(0, 0))
		)
		it('Returns true when i is greater than or equal to the length of the board.', () ->
			tetrisBoard = new TetrisBoard()
			assert(tetrisBoard.isOccupied(config.tetris.TETRIS_LENGTH, 0))
		)
		it('Returns false when i is less than zero. Such squares are invisible but available off the top of the board.', () ->
			tetrisBoard = new TetrisBoard()
			assert(!tetrisBoard.isOccupied(-1, 0))
		)
		it('Returns true when j is out of bounds.', () ->
			tetrisBoard = new TetrisBoard()
			assert(tetrisBoard.isOccupied(0, -1))
			assert(tetrisBoard.isOccupied(0, config.tetris.TETRIS_WIDTH))
		)
	)
	describe('#isColliding(coordinates)', () ->
		rowIndex = columnIndex = tetrisBoard = coordinates =null

		beforeEach(() ->
			rowIndex = config.tetris.TETRIS_LENGTH - 1
			columnIndex = 0
			upperLeftCoordinate = { i: rowIndex, j: columnIndex }
			shape = new IShape()
			tetrisBoard = new TetrisBoard()
			coordinates = TetrisBoard._getTranslatedCoordinates(shape, upperLeftCoordinate)
		)
		it('Returns true if any coordinates in the passed array collide with occupied squares.', () ->
			tetrisBoard.setColor(rowIndex, columnIndex, new Color(1, 1, 1))
			assert(tetrisBoard.isColliding(coordinates))
		)
		it('Returns false if none of the coordinates in the passed array collide with occupied squares.', () ->
			assert(!tetrisBoard.isColliding(coordinates))
		)
	)
	describe('#isFull(row)', () ->
		it('Returns true only if the ith row is occupied in every column.', () ->
			tetrisBoard = new TetrisBoard()
			row = config.tetris.TETRIS_LENGTH - 1
			for j in [0..tetrisBoard.width() - 1]
				tetrisBoard.setColor(row, j, new Color(1, 1, 1))
			assert.strictEqual(tetrisBoard.isFull(row), true)
		)
		it('Returns false when at least one of the squares in the ith row is not occupied.', () ->
			tetrisBoard = new TetrisBoard()
			row = config.tetris.TETRIS_LENGTH - 1
			for j in [0..tetrisBoard.width() - 1]
				tetrisBoard.setColor(row, j, new Color(1, 1, 1))
			tetrisBoard.setColor(row, 0, new Color(0, 0, 0))
			assert.strictEqual(tetrisBoard.isFull(row), false)
		)
		it('Returns false when row is out of bounds.', () ->
			tetrisBoard = new TetrisBoard()
			row = -1
			assert.strictEqual(tetrisBoard.isFull(row), false)
			row = config.tetris.TETRIS_LENGTH
			assert.strictEqual(tetrisBoard.isFull(row), false)
		)
	)
	describe('#getFrame()', () ->
		it('Returns an instance of LEDTable.', () ->
			tetrisBoard = new TetrisBoard()
			assert.instanceOf(tetrisBoard.getFrame(), LEDTable)
		)
		it('Colors inactive squares that have not yet been cleared.', () ->
			tetrisBoard = new TetrisBoard()
			color1 = new Color(50, 50, 50)
			color2 = new Color(100, 100, 100)
			tetrisBoard.setColor(0, 0, color1)
			tetrisBoard.setColor(tetrisBoard.length() - 1, tetrisBoard.width() - 1, color2)
			frame = tetrisBoard.getFrame()
			assert(tetrisBoard.getColor(i, j).equals(frame.get(i, j).getColor())) for j in [0..tetrisBoard.width() - 1] for i in [0..tetrisBoard.length() - 1]
		)
		it('Colors the squares occupied by the activeShape.', () ->
			tetrisBoard = new TetrisBoard()
			shape = new IShape()
			tetrisBoard.setActiveShape(shape)
			tetrisBoard._activeShapePosition = new Coordinate(0, 3)
			frame = tetrisBoard.getFrame()
			assert(frame.get(0, 3).equals(shape.getColor()))
			assert(frame.get(0, 4).equals(shape.getColor()))
			assert(frame.get(0, 5).equals(shape.getColor()))
			assert(frame.get(0, 6).equals(shape.getColor()))
		)
	)
	describe('#_getTranslatedCoordinates(shape)', () ->
		it('Returns the array of coordinates for the Shape after translating the coordinates to the shape\'s position on the board.', () ->
			inputs = [
				{
					shape: new IShape(),
					upperLeftCoordinate: new Coordinate(5, 2)
				},
			]
			expectedOutputs = [
				[
					new Coordinate(5, 2),
					new Coordinate(5, 3),
					new Coordinate(5, 4),
					new Coordinate(5, 5),
				]
			]
			actualOutputs = inputs.map((input) ->
				return TetrisBoard._getTranslatedCoordinates(input.shape, input.upperLeftCoordinate)
			)

			assert.deepEqual(expectedOutputs[i], actualOutputs[i]) for i in [0..inputs.length-1]
		)
	)
)
