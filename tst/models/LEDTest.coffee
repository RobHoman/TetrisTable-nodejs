assert = require('chai').assert
expect = require('chai').expect
ArgumentError = require('../../src/error/ArgumentError').ArgumentError
Color = require('../../src/models/Color').Color
LED = require('../../src/models/LED').LED

describe('LED', () ->
	describe('#constructor(args...)', () ->
		it('Treats 3 arguments as red, green and blue.', () ->
			expectedRed = 63
			expectedGreen = 64
			expectedBlue = 65
			led = new LED(expectedRed, expectedGreen, expectedBlue)
			assert.equal(expectedRed, led.getRed())
			assert.equal(expectedGreen, led.getGreen())
			assert.equal(expectedBlue, led.getBlue())
		)
		it('Treats 1 argument as a Color object', () ->
			expectedRed = 63
			expectedGreen = 64
			expectedBlue = 65
			color = new Color(expectedRed, expectedGreen, expectedBlue)
			led = new LED(color)
			assert.equal(expectedRed, led.getRed())
			assert.equal(expectedGreen, led.getGreen())
			assert.equal(expectedBlue, led.getBlue())
		)
		it('Throws Error when the single argument is not an instance of Color.', () ->
			expect(() ->
				new LED('notAColorObject')
			).to.throw(Error)
		)
		it('Makes black when there are 0 arguments.', () ->
			led = new LED()
			assert.equal(0, led.getRed())
			assert.equal(0, led.getGreen())
			assert.equal(0, led.getBlue())
		)
		it('Throws ArgumentError when there are neither 0, 1 nor 3 arguments.', () ->
			expect(() ->
				new LED('firstBogusArg', 'secondBogusArg')
			).to.throw(ArgumentError)
		)
		it('Does not accept negative arguments.', () ->
			argsList = [[-1, 0, 0], [0, -1, 0], [0, 0, -1]]
			expect(() ->
				new LED(args[0], args[1], args[2])
			).to.throw(RangeError) for args in argsList
		)
		it('Does not accept arguments exceeding 255.', () ->
			argsList = [[256, 0, 0], [0, 256, 0], [0, 0, 256]]
			expect(() ->
				new LED(args[0], args[1], args[2])
			).to.throw(RangeError) for args in argsList
		)
	)

	describe('#copy()', () ->
		it('Returns a new LED object equal to the copied LED object.', () ->
			led = new LED(50, 100, 150)
			assert(led.equals(led.copy()))
		)
	)
)
