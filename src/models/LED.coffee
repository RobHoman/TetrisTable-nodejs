Color = require('./Color').Color

class exports.LED
	
	constructor: (args...) -> 
		if (args.length == 3)
			@color = new Color(args[0], args[1], args[2])
		else if (args.length == 1)
			# TODO: validate that the single arg has type Color
			@color = args[0]
		else
			@color = color ? new Color(0, 0, 0)

	getRed: () ->
		return @color.getRed()

	getGreen: () ->
		return @color.getGreen()

	getBlue: () ->
		return @color.getBlue()
	
	toHexString: () ->
		return @color.toHexString()

	toJSON: () ->
		return json = {
			color: @color.toJSON()
		}
	
