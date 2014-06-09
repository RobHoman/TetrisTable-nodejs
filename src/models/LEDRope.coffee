Color = require('./Color').Color
LED = require('./LED').LED

class exports.LEDRope

	constructor: (n) ->
		@leds = [0..(n - 1)].map -> new LED(
			new Color({
				red: 0,
				green: 0,
				blue: 0,
			})
		)
	
	length: () ->
		return @leds.length
