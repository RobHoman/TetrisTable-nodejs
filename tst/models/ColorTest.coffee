assert = require('chai').assert
expect = require('chai').expect
ArgumentError = require('../../src/error/ArgumentError').ArgumentError
Color = require('../../src/models/Color').Color

describe('Color', () ->
	describe('#constructor(args...)', () ->
		it('Treats 3 arguments as red, green and blue.', () ->
			expectedRed = 63
			expectedGreen = 64
			expectedBlue = 65
			color = new Color(expectedRed, expectedGreen, expectedBlue)
			assert.equal(expectedRed, color.getRed())
			assert.equal(expectedGreen, color.getGreen())
			assert.equal(expectedBlue, color.getBlue())
		)
		it('Makes black when there are 0 arguments.', () ->
			color = new Color()
			assert.equal(0, color.getRed())
			assert.equal(0, color.getGreen())
			assert.equal(0, color.getBlue())
		)
		it('Throws ArgumentError when there are neither 0 nor 3 arguments.', () ->
			expect(() ->
				new Color('oneBogusArg')
			).to.throw(ArgumentError)
		)
		it('Does not accept negative arguments.', () ->
			argsList = [[-1, 0, 0], [0, -1, 0], [0, 0, -1]]
			expect(() ->
				new Color(args[0], args[1], args[2])
			).to.throw(RangeError) for args in argsList
		)
		it('Does not accept arguments exceeding 255.', () ->
			argsList = [[256, 0, 0], [0, 256, 0], [0, 0, 256]]
			expect(() ->
				new Color(args[0], args[1], args[2])
			).to.throw(RangeError) for args in argsList
		)
	)

	describe('#toHexString()', () ->
		it('Prepends return value with a pound sign.', () ->
			color = new Color()
			hexString = color.toHexString()
			assert.equal('#', hexString.charAt(0))
		)
		it('Converts the number to a 24 bit hexadecimal string.', () ->
			color = new Color(10, 65, 139)
			hexString = color.toHexString()
			assert.equal(7, hexString.length)
			assert.equal("0a", hexString.substring(1, 3))
			assert.equal("41", hexString.substring(3, 5))
			assert.equal("8b", hexString.substring(5, 7))
		)
	)

)
