#### IMPORTS ####
### 3rd Party ###

### 1st Party ###
Color = require('../models/Color').Color
LED = require('../models/LED').LED
LEDRope = require('../models/LEDRope').LEDRope

##
# Initialize this controller.
# @param app An express application instance to which endpoints will be registered.
##
init = (app) ->
	app.get('/leds', (req, res) ->
		ledRope = new LEDRope(9)

		context = {
			ledRope: ledRope,
		}

		res.render('led-rope.jade', context)
	)

##
# Expose the init method.
##
exports = module.exports = init
