fs = require 'fs'
module.exports =
  dbPassword: ->
    try
      data = fs.readFileSync "../sensitivedata.json"
      return JSON.parse(data).booksharepassword
    catch e
      return process.env.BOOKSHARE_PASSWORD
    
