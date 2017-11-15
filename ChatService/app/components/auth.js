'use strict';

const errors = require('http-errors');
const User = require('../users/user.schema.js');

module.exports = {

  /**
   * Middleware that checks whether the user is authenticated.
   * Throws a HTTP Unauthorized (401) error otherwise.
   */
  middleware: (req, res, next) => {
    let username;
    let password;
    if (req.method === 'GET') {
      username = req.query.username;
      password = req.query.password;
    } else {
      username = req.body.username;
      password = req.body.password;
    }

    if (!username || !password) return next(new errors.Unauthorized('Wrong username or password.'));

    User.findOne({ username }).exec()
      .then(user => {
        if (!user || user.password !== password) return next(new errors.Unauthorized('Wrong username or password.'));
        req.user = user;
        delete req.user.password;
        User.findOneAndUpdate({ username: user.username }, { last_login: new Date() }).exec()
          .then(oldDoc => {
            return next();
          })
          .catch(() => next(new errors.Unauthorized('Failed saving login information to DB.')));
      })
      .catch(next);
  }
};
