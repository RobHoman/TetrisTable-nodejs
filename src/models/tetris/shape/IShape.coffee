#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
Color = require('../../Color').Color
config = require('../../../config')
Shape = require('./Shape').Shape

class exports.IShape extends Shape

	constructor: () ->
		super()
		@_color = Color.fromHexString(config.tetris.shape.i.COLOR)

	getCoordinates: () ->
		return IShape._ROTATION_STATES[@_rotationStateIndex]

	rotate: () ->
		@_rotationStateIndex++
		if(@_rotationStateIndex >= 2)
			@_rotationStateIndex = 0
		return @

	copy: () ->
		copy = new IShape()
		copy._color = @_color
		copy._rotationStateIndex = @_rotationStateIndex
		return copy

	@_ROTATION_STATES = [
		[
			{ i: 0, j: 0 },
			{ i: 0, j: 1 },
			{ i: 0, j: 2 },
			{ i: 0, j: 3 },
		],
		[
			{ i: 0, j: 2 },
			{ i: 1, j: 2 },
			{ i: 2, j: 2 },
			{ i: 3, j: 2 },
		],
	]
