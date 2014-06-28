#### IMPORTS ####
### 3rd Party ###

### 1st Party ###
LEDTable = require('../models/LEDTable').LEDTable

LENGTH = 10
WIDTH = 20

##
# Initialize this controller.
# @param app An express application instance to which endpoints will be registered.
##
init = (app) ->
	app.get('/table', (req, res) ->
		ledTable = new LEDTable(LENGTH, WIDTH)

		context = {
			ledTable: ledTable,
		}

		res.render('led-table.jade', context)
	)

##
# Expose the init method.
##
exports = module.exports = init
