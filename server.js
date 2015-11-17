#!/bin/env node
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
require('coffee-script/register');

require('./bookshare')(app, io);

http.listen(process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 8080, process.env.OPENSHIFT_NODEJS_IP || process.env.IP || "localhost", function(){
  console.log('listening on *:8080');
});
