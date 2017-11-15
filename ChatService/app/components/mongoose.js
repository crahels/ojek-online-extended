'use strict';

var mongoose = require('mongoose');
const config = require('config');
const winston = require('./winston.js');

mongoose.Promise = global.Promise; // Use native Promise implementation
mongoose.connect(config.get('mongoose').connectionString);

let conn = mongoose.connection;
conn.on('error', (err) => {
  winston.log('error', 'DB connection error:');
  winston.log('error', err);
});

module.exports = mongoose;
