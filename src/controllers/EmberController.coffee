#### IMPORTS ####
### 3rd Party ###

### 1st Party ###

##
# Initialize this controller.
# @param app An express application instance to which endpoints will be registered.
##
init = (app) ->
  app.get('/ember', (req, res) ->
    
    res.render('ember.jade')
  )

##
# Expose the init method.
##
exports = module.exports = init
