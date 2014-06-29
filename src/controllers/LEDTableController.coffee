#### IMPORTS ####
### 3rd Party ###

### 1st Party ###
LEDTable = require('../models/LEDTable').LEDTable


##
# Initialize this controller.
# @param app An express application instance to which endpoints will be registered.
##
init = (app, tableLength, tableWidth) ->
	app.get('/table', (req, res) ->
		ledTable = new LEDTable(tableLength, tableWidth)

		context = {
			ledTable: ledTable,
		}

		res.render('led-table.jade', context)
	)

##
# Expose the init method.
##
exports = module.exports = init
