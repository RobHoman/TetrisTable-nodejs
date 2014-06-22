#### IMPORTS ####
### 3rd Party ###

### 1st Party ###
Color = require('../models/Color').Color
LED = require('../models/LED').LED
LEDTable = require('../models/LEDTable').LEDTable

##
# Initialize this controller.
# @param app An express application instance to which endpoints will be registered.
##
init = (app) ->
	app.get('/table', (req, res) ->
		ledTable = new LEDTable(10, 10)

		context = {
			ledTable: ledTable,
		}

		res.render('led-table.jade', context)
	)

##
# Expose the init method.
##
exports = module.exports = init
