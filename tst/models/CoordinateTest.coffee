assert = require('chai').assert
expect = require('chai').expect
Coordinate = require('../../src/models/Coordinate').Coordinate

describe('Coordinate', () ->
	inputs = [
		new Coordinate(5, 5),
		new Coordinate(9, 10),
	]

	describe('#above()', () ->
		it('Returns the Coordinate directly below it.', () ->
			expectedOutputs = [
				new Coordinate(4, 5),
				new Coordinate(8, 10),
			]
			actualOutputs = inputs.map((input) ->
				return input.above()
			)
			assert(expectedOutputs[i].equals(actualOutputs[i])) for i in [0..inputs.length - 1]
		)
	)
	describe('#below()', () ->
		it('Returns the Coordinate directly above it.', () ->
			expectedOutputs = [
				new Coordinate(6, 5),
				new Coordinate(10, 10),
			]
			actualOutputs = inputs.map((input) ->
				return input.below()
			)
			assert(expectedOutputs[i].equals(actualOutputs[i])) for i in [0..inputs.length - 1]
		)
	)
	describe('#left()', () ->
		it('Returns the Coordinate directly to the left.', () ->
			expectedOutputs = [
				new Coordinate(5, 4),
				new Coordinate(9, 9),
			]
			actualOutputs = inputs.map((input) ->
				return input.left()
			)
			assert(expectedOutputs[i].equals(actualOutputs[i])) for i in [0..inputs.length - 1]
		)
	)
	describe('#right()', () ->
		it('Returns the Coordinate directly to the right.', () ->
			expectedOutputs = [
				new Coordinate(5, 6),
				new Coordinate(9, 11),
			]
			actualOutputs = inputs.map((input) ->
				return input.right()
			)
			assert(expectedOutputs[i].equals(actualOutputs[i])) for i in [0..inputs.length - 1]
		)
	)
)
