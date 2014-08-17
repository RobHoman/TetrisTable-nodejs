#### IMPORTS ####
### 3rd Party ###
assert = require('chai').assert
expect = require('chai').expect
### 1st Party ###
ArgumentError = require('../../src/error/ArgumentError').ArgumentError
Color = require('../../src/models/Color').Color
Coordinate = require('../../src/models/Coordinate').Coordinate
LED = require('../../src/models/LED').LED
LEDTable = require('../../src/models/LEDTable').LEDTable

describe('LEDTable', () ->
	describe('#constructor(length, width)', () ->
		it('Initializes every LED to black.', () ->
			ledTable = new LEDTable(15, 15)
			blackLED = new LED(0, 0, 0)
			assert(ledTable.get(i, j).equals(blackLED)) for j in [0..ledTable.width() - 1] for i in [0..ledTable.length() - 1]
		)
	)
	describe('#get(args...)', () ->
		ledTable = null
		beforeEach(() ->
			ledTable = new LEDTable(10, 5)
		)
		it('Treats a single argument as a Coordinate object', () ->
			expect(() ->
				ledTable.get('notACoordinateObject')
			).to.throw(Error)
		)
		it('Treats two arguments as row and column indices', () ->
			assert.instanceOf(ledTable.get(0, 0), LED)
		)
		it('Does not accept less than 1 args.', () ->
			expect(() ->
				ledTable.get()
			).to.throw(ArgumentError)
		)
		it('Does not accept more than 2 args.', () ->
			expect(() ->
				ledTable.get(0, 0, 'thirdArg')
			).to.throw(ArgumentError)
		)
	)
	describe('#set(args...)', () ->
		ledTable = null
		beforeEach(() ->
			ledTable = new LEDTable(10, 5)
		)
		it('Treats two arguments as a Coordinate object and an LED object.', () ->
			expect(() ->
				ledTable.set('notACoordinateObject', new LED(0, 0, 0))
			).to.throw(Error)
			expect(() ->
				ledTable.set(new Coordinate(0, 0), 'notAnLEDObject')
			).to.throw(Error)
		)
		it('Treats three arguments as a row index, column index, and LED object.', () ->
			expect(() ->
				ledTable.set(0, 0,  'notAnLEDObject')
			).to.throw(Error)
		)
		it('Does not accept less than 2 args.', () ->
			expect(() ->
				ledTable.set(0)
			).to.throw(ArgumentError)
		)
		it('Does not accept more than 3 args.', () ->
			expect(() ->
				ledTable.set(0, 0, new LED(0, 0, 0),'fourthArg')
			).to.throw(ArgumentError)
		)
	)
	describe('#from2DColorArray(colorArray)', () ->
		it('Converts a two-dimensional array of colors into an LEDTable with the same coloring.', () ->
			length = 10
			width = 20
			colorArray = [0..length - 1].map (i) ->
				[0..width - 1].map (j) ->
					new Color(20, 20, 20)
			ledTable = LEDTable.from2DColorArray(colorArray)
			assert(ledTable.get(i, j).getColor().equals(new Color(20, 20, 20))) for j in [0..width - 1] for i in [0..length - 1]

		)
	)
)
