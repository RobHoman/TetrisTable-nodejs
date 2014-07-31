#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###

class exports.Shape

	@_color
	@_rotationStateIndex

	constructor: () ->
		@_rotationStateIndex = 0

	getColor: () ->
		return @_color

	getCoordinates: () ->
		throw new Exception('Method \'getCoordinates\' must be implemented in the subclass.')

	rotate: () ->
		throw new Exception('Method \'rotate\' must be implemented in the subclass.')

	copy: () ->
		throw new Exception('Method \'copy\' must be implemented in the subclass.')
