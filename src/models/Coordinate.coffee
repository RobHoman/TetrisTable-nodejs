#### IMPORTS ####
### 3rd Party ###
assert = require('chai').assert
### 1st Party ###

##
# Use i and j to represent a rowIndex and columnIndex, respectively.
# Increasing i moves you downward in the space; increasing j moves
# you rightward in the space.
##
class exports.Coordinate

	@i
	@j

	constructor: (i, j) ->
		@i = i
		@j = j

	##
	# Return the coordinate directly above this one.
	##
	above: () ->
		return new Coordinate(@i - 1, @j)
	##
	# Return the coordinate directly below this one.
	##
	below: () ->
		return new Coordinate(@i + 1, @j)
	##
	# Return the coordinate to the left of this one.
	##
	left: () ->
		return new Coordinate(@i, @j - 1)
	##
	# Return the coordinate to the right of this one.
	##
	right: () ->
		return new Coordinate(@i, @j + 1)

	equals: (other) ->
		if !(other instanceof Coordinate)
			return false
		return (other.i == @i and other.j == @j)

