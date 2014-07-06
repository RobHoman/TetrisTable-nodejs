#### IMPORTS ####
### 3rd Party ###

### 1st Party ###
config = require('../config')
LEDTable = require('../models/LEDTable').LEDTable


##
# Initialize this controller.
# @param app An express application instance to which endpoints will be registered.
##
init = (app) ->
	app.get('/table', (req, res) ->
		ledTable = new LEDTable(config.TABLE_LENGTH, config.TABLE_WIDTH)

		context = {
			ledTable: ledTable,
		}

		res.render('led-table.jade', context)
	)

##
# Expose the init method.
##
exports = module.exports = init
