'use strict';

const errors = require('http-errors');
const User = require('../users/user.schema.js');
const fetch = require('node-fetch');

function getIdentifier(req) {
  let ip = req.connection.remoteAddress;
  if (!ip) ip = '';
  ip = ip.replace(/^.*:/, ''); // remove leading :ffff due to ipv6 compatibility, to be compatible with java
  let ua = req.headers['user-agent']; // lowercase
  if (!ua) ua = '';
  let identifier = ip + "###" + ua;
  console.log(identifier);
  return identifier;
}

module.exports = {
  /**
   * Middleware that checks whether the user is authenticated.
   * Throws a HTTP Unauthorized (401) error otherwise.
   */
  middleware: (req, res, next) => {
    let username;
    let token;
    if (req.method === 'GET') {
      username = req.query.username;
      token = req.query.token;
    } else {
      username = req.body.username;
      token = req.body.token;
    }

    if (!username || !token) {
      return next(
        new errors.Unauthorized('Username and token cannot be empty.')
      );
    }

    const param = { username, token, identifier: getIdentifier(req) };
    const formBody = Object.keys(param)
      .map(
        key => encodeURIComponent(key) + '=' + encodeURIComponent(param[key])
      )
      .join('&');

    fetch('http://glassfish_identityservice:8080/validate', {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: formBody
    })
      .then(response => response.json())
      .then(json => {
        if(!json.username) next(new errors.Unauthorized('Token is not verified'));
        return User.findOneAndUpdate({ username }, { last_login: new Date() }).exec();
      })
      .then(user => {
        if (!user) {
          let newUser = new User({
            username: req.body.username,
            tokenFCM: req.body.tokenFCM,
            online: true,
            orderedBy: null,
            history: [],
            last_login: new Date()
          });
          newUser.save().then(next());
        }
      
        return next();
      })
      .catch(next);
  }
};
