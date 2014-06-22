Color = require('./Color').Color
LED = require('./LED').LED

class exports.LEDTable

	##
	# Construct a Table of LEDs. Length is the primary index
	# and width is the secondary index of the 2D array of LEDs.
	##
	constructor: (length, width) ->
		@leds = [0..(length - 1)].map () ->
			[0..(width - 1)].map () ->
				new LED(
					new Color({
						red: 0,
						green: 0,
						blue: 0,
					})
				)
	get: (i, j) ->
		return @leds[i][j]
	length: () ->
		return @leds.length
	width: () ->
		return @leds[0].length
