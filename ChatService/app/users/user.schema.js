'use strict';

const mongoose = require('../components/mongoose.js');

const historySchema = mongoose.Schema(
  {
    from: { type: String, required: true },
    to: { type: String, required: true },
    message: { type: String, required: true },
    timestamp: { type: Date, default: Date.now }
  },
  { _id: false }
);

const userSchema = mongoose.Schema({
  username: { type: String, required: true, unique: true },
  tokenFCM: String,
  online: { type: Boolean, required: true },
  orderedBy: { type: String },
  last_login: Date,
  history: [historySchema]
});

module.exports = mongoose.model('User', userSchema);
