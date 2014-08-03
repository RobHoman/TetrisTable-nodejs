#### IMPORTS ####
### 3rd Party ###
assert = require('chai').assert
### 1st Party ###
ArgumentError = require('../error/ArgumentError').ArgumentError
Color = require('./Color').Color
Coordinate = require('./Coordinate').Coordinate
LED = require('./LED').LED

##
# The LEDTable class wraps a 2D array of LED objects,
# providing convenience methods for interacting with
# a tabular arrangement of LED objects. Length is the
# primary index while width is the secondary index.
##
class exports.LEDTable

	@_leds

	##
	# Construct a Table of LEDs with a certain length
	# and width. Initialize every LED to black.
	# @param length The length of the new table
	# @param width The width of the new table
	##
	constructor: (length, width) ->
		@_leds = [0..(length - 1)].map () ->
			[0..(width - 1)].map () ->
				new LED(0, 0, 0)
	
	##
	# Get an LED at a coordinate. 
	# @param args... A single argument is treated as
	# an instance of Coordinate. Two arguments are
	# treated as length, width indices respectively.
	##
	get: (args...) ->
		i = j = null
		if(args.length == 1)
			assert.instanceOf(args[0], Coordinate, 'A single argument must be an instance of Coordinate.')
			i = args[0].i
			j = args[0].j
		else if(args.length == 2)
			i = args[0]
			j = args[1]
		else
			throw new ArgumentError('#get(args...) accepts only 1 or 2 arguments')

		return @_leds[i][j]

	##
	# Set an LED at a coordinate.
	# @param args... Two arguments are treated as
	# an instance of Coordinate and an instance of
	# LED. Three arguments are treated as length,
	# width indices, followed by an instance of LED.
	##
	set: (args...) ->
		i = j = led = null
		if(args.length == 2)
			assert.instanceOf(args[0], Coordinate, 'The first of two arguments must be an instance of Coordinate.')
			assert.instanceOf(args[1], LED, 'The second of two arguments must be an instance of LED.')
			i = args[0].i
			j = args[0].j
			led = args[1]
		else if(args.length == 3)
			assert.instanceOf(args[2], LED, 'The third of three arguments must be an instance of LED.')
			i = args[0]
			j = args[1]
			led = args[2]
		else
			throw new ArgumentError('#get(args...) accepts only 2 or 3 arguments')

		@_leds[i][j] = led
		return

	##
	# Get the length of this table.
	##
	length: () ->
		return @_leds.length

	##
	# Get the width of this table.
	##
	width: () ->
		return @_leds[0].length

	##
	# Returns a copy of this LEDTable instance.
	##
	copy: () ->
		ledTable = new LEDTable(this.length(), this.width())
		[0..(this.length() - 1)].map (i) =>
			[0..(this.width() - 1)].map (j) =>
				ledTable.set(i, j, this.get(i, j).copy())
		return ledTable
