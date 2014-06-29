class exports.Color

	constructor: (args) ->
		@red = args?.red ? 0
		@green = args?.green ? 0
		@blue = args?.blue ? 0
		
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
