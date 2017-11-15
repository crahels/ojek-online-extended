'use strict';

const mongoose = require('../components/mongoose.js');

const userSchema = mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  display_name: String,
  scores: [{
    course: String,
    score: Number
  }],
  presence: [{
    location: String,
    time: { type: Date, default: Date.now }
  }],
  last_login: Date
});

module.exports = mongoose.model('User', userSchema);
