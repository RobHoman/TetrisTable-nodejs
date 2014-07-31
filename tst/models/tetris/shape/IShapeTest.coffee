#### IMPORTS ####
### 3RD PARTY ###
assert = require('chai').assert
expect = require('chai').expect

### 1ST PARTY ###
config = require('../../../../src/config')
Color = require('../../../../src/models/Color').Color
IShape = require('../../../../src/models/tetris/shape/IShape').IShape

describe('IShape', () ->
	describe('#constructor()', () ->
		it('Uses the IShape color from the config.', () ->
			iShape = new IShape()
			expectedColor = Color.fromHexString(config.tetris.shape.i.COLOR)
			assert(iShape.getColor().equals(expectedColor))
		)
	)
	describe('#rotate()', () ->
		it('Rotates the IShape by advancing it to the next rotation state, mod 2.', () ->
			iShape = new IShape()
			assert.equal(0, iShape._rotationStateIndex)
			iShape.rotate()
			assert.equal(1, iShape._rotationStateIndex)
			iShape.rotate()
			assert.equal(0, iShape._rotationStateIndex)
		)
	)
)
