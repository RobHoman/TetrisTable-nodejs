#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
Color = require('../../Color').Color
config = require('../../../config')
Shape = require('./Shape').Shape

class exports.OShape extends Shape

	constructor: () ->
		super()
		@_color = Color.fromHexString(config.tetris.shape.o.COLOR)

	getCoordinates: () ->
		return OShape._ROTATION_STATE

	rotate: () ->
		return @

	copy: () ->
		copy = new OShape()
		copy._color = @_color
		copy._rotationStateIndex = @_rotationStateIndex
		return copy

	@_ROTATION_STATE = [
		{ i: 0, j: 0 },
		{ i: 0, j: 1 },
		{ i: 1, j: 0 },
		{ i: 1, j: 1 },
	]

