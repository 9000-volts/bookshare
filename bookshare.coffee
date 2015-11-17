mailer = require "./mailer"
database = require "./database"
module.exports = (app, io) ->
  mailer.sendDemoMessage()

  app.get '/', (req, res) -> res.sendfile 'bookshare/index.html'

  app.get '/listings', (req, res) -> res.sendfile 'bookshare/listings.html'

  app.get '/style.css', (req, res) -> res.sendfile 'bookshare/style.css'

  app.get '/background.jpg', (req, res) ->
    res.sendfile 'bookshare/background.jpg'

  io.on 'connection', (socket) ->
    socket.on 'connection-bookshare-homepage', ->
      socket.emit 'stats', database.listings().length

    socket.on 'connection-bookshare-listings', ->
      socket.emit 'listings', database.listings().map (listing) ->
        information: listing.information
        index: listing.index

      socket.on 'request-listing', database.sendListingRequest
      socket.on 'add-listing', (email, information) ->
        database.addListing email, information
        socket.emit 'reload'
      socket.on 'remove-listing', (index, code) ->
        database.removeListing index, code
        socket.emit 'reload'
