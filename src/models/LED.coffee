Color = require('./Color').Color

class exports.LED
	
	constructor: (args...) -> 
		if (args.length == 3)
			@color = new Color({
				red: args[0],
				green: args[1],
				blue: args[2],
			})
		else if (args.length == 1)
			# TODO: validate that the single arg has type Color
			@color = args[0]
		else
			@color = color ? new Color({
				red: 0,
				green: 0,
				blue: 0,
			})

	
	toJSON: () ->
		return json = {
			color: @color.toJSON()
		}
	
