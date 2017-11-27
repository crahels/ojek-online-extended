'use strict';

const express = require('express');
const firebase = require('firebase-admin');
const pick = require('lodash/pick');
const config = require('config');
const errors = require('http-errors');
const auth = require('../components/auth.js');
const User = require('./user.schema.js');

const router = express.Router();

firebase.initializeApp({
  credential: firebase.credential.cert(config.get('fcm')),
  databaseURL: 'https://tubes-3-wbd-c0ef6.firebaseio.com'
});

router.get('/', (req, res, next) => {
  return res.json({
    message: "Hello world! This is Chat Service's API server."
  });
});

router.get('/profile', auth.middleware, (req, res, next) => {
  return res.json(req.user);
});

router.post('/history', (req, res, next) => {
  if (!req.body.from || !req.body.to || !req.body.token) {
    return next(
      new errors.UnprocessableEntity(
        'Missing username or identity token or token FCM or driver'
      )
    );
  }

  User.aggregate(
    { $match: { username: req.body.from } },
    {
      $project: {
        _id: 0,
        history: {
          $filter: {
            input: '$history',
            as: 'hist',
            cond: {
              $eq: ['$$hist.to', req.body.to]
            }
          }
        }
      }
    }
  )
    .then(user => {
      res.json(user[0].history);
    })
    .catch(next);
});

router.post('/startchat', auth.middleware, (req, res, next) => {
  if (
    !req.body.username ||
    !req.body.token ||
    !req.body.tokenFCM ||
    !req.body.driver
  ) {
    return next(
      new errors.UnprocessableEntity(
        'Missing username or identity token or token FCM or driver'
      )
    );
  }

  User.findOneAndUpdate(
    { username: req.body.username },
    { $set: { online: true } },
    { new: true }
  )
    .then(user => {
      return User.findOneAndUpdate(
        { username: req.body.driver },
        { $set: { orderedBy: req.body.username } },
        { new: true }
      );
    })
    .then(driver => {
      res.sendStatus(200);
    })
    .catch(next);
});

router.post('/listdriver', auth.middleware, (req, res, next) => {
  if (
    !req.body.username ||
    !req.body.token ||
    !req.body.other_drivers ||
    !req.body.preferred_driver
  ) {
    return next(
      new errors.UnprocessableEntity(
        'Missing preferred driver and other driver'
      )
    );
  }

  User.find({})
    .then(arrUser => {
      const preferred_driver = req.body.preferred_driver.filter(driver => {
        return arrUser.some(
          val =>
            val.username === driver.username && val.online && !val.orderedBy
        );
      });

      const other_drivers = req.body.other_drivers.filter(driver => {
        return arrUser.some(
          val =>
            val.username === driver.username && val.online && !val.orderedBy
        );
      });

      res.json({
        preferred_driver,
        other_drivers
      });
    })
    .catch(next);
});

router.post('/updatetoken', auth.middleware, (req, res, next) => {
  if (!req.body.username || !req.body.token || !req.body.tokenFCM) {
    return next(
      new errors.UnprocessableEntity('Missing username, token, and tokenFCM')
    );
  }

  User.findOneAndUpdate(
    { username: req.body.username },
    { $set: { tokenFCM: req.body.tokenFCM } },
    { new: true }
  )
    .then(() => res.sendStatus(200))
    .catch(next);
});

router.post('/endorder', auth.middleware, (req, res, next) => {
  if (!req.body.username || !req.body.token || !req.body.driver) {
    return next(
      new errors.UnprocessableEntity(
        'Missing username or identity token or driver'
      )
    );
  }

  User.findOneAndUpdate(
    { username: req.body.username },
    { $set: { online: false } },
    { new: true }
  )
    .then(user => {
      User.findOneAndUpdate(
        { username: req.body.driver },
        { $set: { orderedBy: null, online: false } },
        { new: true }
      ).then(driver => res.sendStatus(200));
    })
    .catch(next);
});

router.post('/cancelorder', auth.middleware, (req, res, next) => {
  if (!req.body.username || !req.body.token) {
    return next(
      new errors.UnprocessableEntity('Missing username or identity token')
    );
  }

  User.findOneAndUpdate(
    { username: req.body.username },
    { $set: { online: false } },
    { new: true }
  )
    .then(user => res.sendStatus(200))
    .catch(next);
});

router.post('/checkorder', auth.middleware, (req, res, next) => {
  if (!req.body.username || !req.body.token) {
    return next(
      new errors.UnprocessableEntity('Missing username or identity token')
    );
  }

  User.findOne({ username: req.body.username })
    .then(user => res.json({ status: !!user.orderedBy, orderedBy: user.orderedBy }))
    .catch(next);
});

router.post('/checkendorder', auth.middleware, (req, res, next) => {
  if (!req.body.username || !req.body.token) {
    return next(
      new errors.UnprocessableEntity('Missing username or identity token')
    );
  }

  User.findOne({ username: req.body.username })
    .then(user => res.json({ status: !user.orderedBy }))
    .catch(next);
});

router.post('/findorder', auth.middleware, (req, res, next) => {
  if (!req.body.username || !req.body.token) {
    return next(
      new errors.UnprocessableEntity('Missing username or identity token')
    );
  }

  User.findOneAndUpdate(
    { username: req.body.username },
    { $set: { online: true } },
    { new: true }
  )
    .then(user => {
      res.sendStatus(200);
    })
    .catch(next);
});

router.post('/sendchat', auth.middleware, (req, res, next) => {
  if (!req.body.from || !req.body.to || !req.body.token || !req.body.message) {
    return next(
      new errors.UnprocessableEntity(
        'Missing from username or identity token or username from or message'
      )
    );
  }

  let history = pick(req.body, ['from', 'to', 'message']);
  history.timestamp = new Date().toString();

  User.findOne({ username: req.body.to })
    .then(user => {
      let payload = Object.assign({}, pick(req.body, ['to', 'message']));
      payload.timestamp = new Date().toString();
      return firebase
        .messaging()
        .sendToDevice(user.tokenFCM, { data: payload });
    })
    .then(response => {
      const status = response.results.some(elem => !elem.error);
      if (status) {
        return User.findOneAndUpdate(
          { username: req.body.from },
          { $push: { history } }
        );
      }
      throw new errors.BadRequest('Bad message request');
    })
    .then(() => res.json(history))
    .catch(next);
});

module.exports = router;
