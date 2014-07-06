#### IMPORTS ####
### 3RD PARTY ###

### 1ST PARTY ###
config = require('../../../config')
Color = require('../../Color').Color
Shape = require('./Shape').Shape

class exports.IShape extends Shape

	@rotationSwitch

	constructor: () ->
		@rotationSwitch = true
		@color = new Color(0, 255, 255)

		tetrisLength = config.tetris.TETRIS_LENGTH
		tetrisWidth = config.tetris.TETRIS_WIDTH

		middle = Math.floor(tetrisWidth / 2)
		
		@coordinates = [(middle - 2)..(middle + 1)].map (j) ->
			{
				i: 0,
				j: j,
			}

	

	rotate: (tetrisBoard) ->
		if (@rotationSwitch)
			startI = @coordinates[0].i - 2
			j = @coordinates[0].j + 1

			@coordinates = [startI..startI + 3].map (i) ->
				{
					i: i,
					j: j,
				}
		else
			i = @coordinates[0].i + 2
			startJ = @coordinates[0].j - 1

			@coordinates = [startJ..startJ + 3].map (j) ->
				{
					i: i,
					j: j,
				}

		@rotationSwitch = !@rotationSwitch

	copy: () ->
		copyShape = new IShape()
		copyShape.rotationSwitch = @rotationSwitch
		copyShape.color = @color
		copyShape.coordinates = @coordinates
		return copyShape


