Color = require('./Color').Color

class exports.LED
	
	constructor: (color) -> 
		@color = color ? new Color({
			red: 0,
			green: 0,
			blue: 0,
		})

	
	toJSON: () ->
		return json = {
			color: @color.toJSON()
		}
	
