#### IMPORTS ####
### 3rd Party ###
assert = require('chai').assert

### 1st Party ###
ArgumentError = require('../error/ArgumentError').ArgumentError

class exports.Color
	@_red
	@_green
	@_blue

	constructor: (args...) ->
		if (args.length == 3)
			@_red = args[0]
			@_green = args[1]
			@_blue = args[2]
		else if(args.length == 0)
			@_red = 0
			@_green = 0
			@_blue = 0
		else
			throw new ArgumentError('The Color constructor only accepts 0 or 3 arguments.')

		validateRange(integer) for integer in [@_red, @_green, @_blue]

	getRed: () ->
		return @_red

	getGreen: () ->
		return @_green

	getBlue: () ->
		return @_blue

	equals: (other) ->
		if !(other instanceof Color)
			return false
		return (@_red == other.getRed() and @_green == other.getGreen() and @_blue == other.getBlue())

	toHexString: () ->
		return '#' + convertToHex(@_red) + convertToHex(@_green) + convertToHex(@_blue)

	toJSON: () ->
		return json = {
                        red: @_red,
                        green: @_green,
                        blue: @_blue,
                }

	# @ sign makes this a static method, attached directly to
	# the Color object, rather than to its prototype
	@fromHexString: (hexString) ->
		assert.equal(7, hexString.length)
		assert.equal('#', hexString.charAt(0))
	
		red = parseInt(hexString.substring(1, 3), 16)
		green = parseInt(hexString.substring(3, 5), 16)
		blue = parseInt(hexString.substring(5, 7), 16)
	
		return new Color(red, green, blue)

# private methods
convertToHex = (integer) ->
	str = Number(integer).toString(16)
	# prepend a '0' to numbers that are a single hexit long
	return if str.length == 1 then "0" + str else str

validateRange = (integer) ->
	if (integer < 0 or integer > 255)
		throw new RangeError('The Color constructor only accepts integer arguments between 0 and 255 inclusive.')
