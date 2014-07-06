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
				new LED(0, 0, 0)
	get: (i, j) ->
		return @leds[i][j]
	
	set: (i, j, led) ->
		#TODO: Validate that the object has type LED
		@leds[i][j] = led
		return

	length: () ->
		return @leds.length
	width: () ->
		return @leds[0].length

	##
	# Returns a copy of this LEDTable instance.
	##
	copy: () ->
		ledTable = new LEDTable(this.length(), this.width())
		[0..(this.length() - 1)].map (i) =>
			[0..(this.width() - 1)].map (j) =>
				ledTable.set(i, j, this.get(i, j).copy())
		return ledTable
