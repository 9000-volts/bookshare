nodemailer = require 'nodemailer' # http://nodemailer.com/
transporter = nodemailer.createTransport
  service: 'Gmail'
  auth:
    user: 'booksharingcucc@gmail.com'
    pass: process.env.BOOKSHARE_PASSWORD

module.exports =
  sendListingRequestMessage: (email, takedowncode, information, address) ->
    mailOptions =
      to: email
      subject: "Book Requested!"
      text: """
      > Book Requested!
      Your book on bookworld.cu.cc has been requested!
      Title: '#{information}'.
      Please mail the book to '#{address}' and delete your listing.
      To remove your listing, use the code '#{takedowncode}'!
      """
      html: """
      <h1>Book Requested!</h1>
      Your book listing on bookworld.cu.cc has been requested!<br/>
      <b>Title: </b>#{information}<br/>
      Please mail the book to <b>#{address}</b> and delete your listing.<br/>
      To remove your listing, use the code <b>#{takedowncode}</b>!
      """

    transporter.sendMail mailOptions, (error, info) ->
      console.log error if error

  sendListingAddedMessage: (email, takedowncode, information) ->
    mailOptions =
      to: email
      subject: "Book Listing Added!"
      text: """
      > Book Listing Added!
      Your book listing has been added to bookworld.cu.cc!
      Title: '#{information}'.
      To remove your listing, use the code '#{takedowncode}'!
      """
      html: """
      <h1>Book Listing Added!</h1>
      Your book listing has been added to bookworld.cu.cc!<br/>
      <b>Title: </b>#{information}
      To remove your listing, use the code <b>#{takedowncode}</b>!
      """
    transporter.sendMail mailOptions, (error, info) ->
      console.log error if error
