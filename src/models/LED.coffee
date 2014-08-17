#### IMPORTS ####
### 3rd Party ###
assert = require('chai').assert
### 1st Party ###
ArgumentError = require('../error/ArgumentError').ArgumentError
Color = require('./Color').Color

class exports.LED

	@color
	
	constructor: (args...) ->
		if (args.length == 3)
			@color = new Color(args[0], args[1], args[2])
		else if (args.length == 1)
			assert.instanceOf(args[0], Color, 'The single argument must be an instance of Color')
			@color = args[0].copy()
			
		else if (args.length == 0)
			@color = new Color(0, 0, 0)
		else
			throw new ArgumentError('The LED constructor only accepts 0, 1 or 3 arguments.')

	getRed: () ->
		return @color.getRed()

	getGreen: () ->
		return @color.getGreen()

	getBlue: () ->
		return @color.getBlue()

	getColor: () ->
		return @color
	
	toHexString: () ->
		return @color.toHexString()

	toJSON: () ->
		return json = {
			color: @color.toJSON()
		}
	
	copy: () ->
		return new LED(this.getRed(), this.getGreen(), this.getBlue())

	equals: (other) ->
		if (other.getRed() == this.getRed() and other.getGreen() == this.getGreen() and other.getBlue() == this.getBlue())
			return true
		return false
