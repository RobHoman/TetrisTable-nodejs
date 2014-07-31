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
	describe('#fromHexString()', () ->
		it('Accepts length 7 strings prepended with #.', () ->
			validStrings = ['#ff0909', '#000000', '#123456', '#abcdef']
			assert.instanceOf(Color.fromHexString(string), Color) for string in validStrings
		)
		it('Rejects strings that are not length 7.', () ->
			invalidStrings = ['f0909', '00000000', '', 'f', '123456789']
			expect(() ->
				Color.fromHexString(string)
			).to.throw(Error) for strings in invalidStrings
		)
		it('Rejects strings that do not begin with #.', () ->
			invalidStrings = ['af09039', 'p123456', '1234567']
			expect(() ->
				Color.fromHexString(string)
			).to.throw(Error) for strings in invalidStrings
		)
		it('Converts a 24 bit hexadecimal number into the correct Color.', () ->
			inputs = ['#0a418b', '#123456', '#ffcece', '#000102']
			expectedOutputs = [new Color(10, 65, 139), new Color(18, 52, 86), new Color(255, 206, 206), new Color(0, 1, 2)]

			assert(Color.fromHexString(inputs[i]).equals(expectedOutputs[i])) for i in [0..inputs.length-1]
		)
	)
)
