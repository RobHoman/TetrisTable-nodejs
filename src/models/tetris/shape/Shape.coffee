#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###

##
# A shape contains references to the list of coordinates labeling the
# squares that it currently occupies.
# Negative coordinates mean the shape is currently offscreen.
##
class exports.Shape

	@color
	@coordinates

	constructor: () ->

	getColor: () ->
		return @color

	collides: (tetrisBoard) ->
		for coordinate in @coordinates
			if tetrisBoard.isOccupied(coordinate.i, coordinate.j)
				return true
		return false

	##
	# Check if this shape collides with anything on the passed in tetris board
	# by checking if any of the squares below its coordinates are occupied
	##
	collidesDown: (tetrisBoard) ->
		for coordinate in @coordinates
			if tetrisBoard.isOccupied(coordinate.i + 1, coordinate.j)
				return true
		return false

	collidesLeft: (tetrisBoard) ->
		for coordinate in @coordinates
			if tetrisBoard.isOccupied(coordinate.i, coordinate.j - 1)
				return true

		return false

	collidesRight: (tetrisBoard) ->
		for coordinate in @coordinates
			if tetrisBoard.isOccupied(coordinate.i, coordinate.j + 1)
				return true

		return false

	moveUp: () ->
		@coordinates = @coordinates.map (coordinate) ->
			{
				i: coordinate.i - 1
				j: coordinate.j
			}

	moveDown: () ->
		@coordinates = @coordinates.map (coordinate) ->
			{
				i: coordinate.i + 1
				j: coordinate.j
			}

	moveLeft: () ->
		@coordinates = @coordinates.map (coordinate) ->
			{
				i: coordinate.i
				j: coordinate.j - 1
			}

	moveRight: () ->
		@coordinates = @coordinates.map (coordinate) ->
			{
				i: coordinate.i
				j: coordinate.j + 1
			}

	rotate: () ->


exports.Shape.I_SHAPE = "I"
exports.Shape.J_SHAPE = "J"
exports.Shape.L_SHAPE = "L"
exports.Shape.S_SHAPE = "S"
exports.Shape.Z_SHAPE = "Z"
exports.Shape.T_SHAPE = "T"
exports.Shape.O_SHAPE = "O"
