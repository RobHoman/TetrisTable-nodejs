assert = require('chai').assert
expect = require('chai').expect
ArgumentError = require('../../src/error/ArgumentError').ArgumentError
Color = require('../../src/models/Color').Color
LED = require('../../src/models/LED').LED
LEDTable = require('../../src/models/LEDTable').LEDTable

describe('LEDTable', () ->
	describe('#copy()', () ->
		it('Returns a new LEDTable object equal to the copied LEDTable object.', () ->
			ledTable = new LEDTable(20, 10)
			copy = ledTable.copy()
			assert.equal(ledTable.get(i, j), copy.get(i, j)) for j in ledTable.width() for i in ledTable.length()
		)
	)
)
