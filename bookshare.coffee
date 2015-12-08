mailer = require "./mailer"
database = require "./database"
validcategories = ["mag", "sci", "nf", "fic"]
module.exports = (app, io) ->

  app.get '/', (req, res) -> res.sendfile 'bookshare/index.html'

  app.get '/style.css', (req, res) -> res.sendfile 'bookshare/style.css'

  app.get '/logic.js', (req, res) -> res.sendfile 'bookshare/logic.js'

  io.on 'connection', (socket) ->
    socket.emit 'listings', database.listings().map (listing) ->
      information: listing.information
      index: listing.index
      category: listing.category

    socket.on 'request-listing', database.sendListingRequest
    socket.on 'add-listing', (email, information, category) ->
      if validcategories.indexOf category isnt -1
        database.addListing email, information, category
        socket.emit 'reload'
    socket.on 'remove-listing', (index, code) ->
      database.removeListing index, code
      socket.emit 'reload'
