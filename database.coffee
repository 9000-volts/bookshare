dbpath = (process.env.OPENSHIFT_DATA_DIR || ".") + "/booksharedb.json"
fs = require "fs"
mailer = require "./mailer"
db =
  listings: []

fs.readFile dbpath, (err, data) -> db = JSON.parse data if !err
savedb = ->
  fs.writeFile dbpath, JSON.stringify(db), (err) ->
    console.error "FAILED TO SAVE TO DATABASE" if err

module.exports =
  listings: -> db.listings.filter (listing) -> if listing then true else false
  addListing: (email, information, category) ->
    index = db.listings.length
    db.listings.push
      email: email
      takedowncode: Math.floor(10000 + Math.random() * 80000)
      information: information
      index: index
      category: category
    mailer.sendListingAddedMessage email, db.listings[index].takedowncode,
    information
    savedb()
  removeListing: (index, code) ->
    if db.listings[index].takedowncode is parseInt(code) or
    code is require("./getsensitivedata").dbPassword()
      db.listings[index] = undefined
      savedb()
  sendListingRequest: (index, address) ->
    mailer.sendListingRequestMessage db.listings[index].email,
    db.listings[index].takedowncode,
    db.listings[index].information, address if db.listings[index]
