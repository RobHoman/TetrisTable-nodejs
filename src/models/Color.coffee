class exports.Color

	constructor: (args...) ->
		#TODO: validate that the rgb values are between 0 and 255
		if (args.length == 3)
			@red = args[0]
			@green = args[1]
			@blue = args[2]
		else if (args.length == 1)
			@red = args?.red ? 0
			@green = args?.green ? 0
			@blue = args?.blue ? 0
		else
			@red = 0
			@green = 0
			@blue = 0

	getRed: () ->
		return @red

	getGreen: () ->
		return @green

	getBlue: () ->
		return @blue

	toHexString: () ->
		return '#' + convertToHex(@red) + convertToHex(@green) + convertToHex(@blue)

	toJSON: () ->
		return json = {
                        red: @red,
                        green: @green,
                        blue: @blue,
                }

# private methods
convertToHex = (integer) ->
	str = Number(integer).toString(16)
	# prepend a '0' to numbers that are a single hexit long
	return if str.length == 1 then "0" + str else str
