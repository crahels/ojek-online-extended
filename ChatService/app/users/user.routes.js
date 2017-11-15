'use strict';

const express = require('express');
const config = require('config');
const errors = require('http-errors');
const auth = require('../components/auth.js');
const User = require('./user.schema.js');

const router = express.Router();

router.get('/', (req, res, next) => {
  return res.json({ message: 'Hello world! This is Learnguage\'s API server.' });
});

router.get('/profile', auth.middleware, (req, res, next) => {
  return res.json(req.user);
});

router.get('/summary', auth.middleware, (req, res, next) => {
  const user = req.user;
  let averageScore = 0.0;
  let presenceRecap = 0;
  if (user !== null && user !== undefined) {
    let scoreSum = 0.0;
    for (let i = 0; i < user.scores.length; i++) {
      scoreSum += user.scores[i].score;
    }
    if (user.scores.length > 0) averageScore = scoreSum / user.scores.length;
    presenceRecap = user.presence.length;
  }
  return res.json({ averageScore, presenceRecap });
});

router.get('/scores', auth.middleware, (req, res, next) => {
  return res.json(req.user.scores);
});

router.get('/presence', auth.middleware, (req, res, next) => {
  return res.json(req.user.presence);
});

router.post('/register', (req, res, next) => {
  if (!req.body.username || !req.body.password) return next(new errors.UnprocessableEntity('Missing username or password.'));

  if (config.get('registrationKey') !== req.body.registrationKey) {
    return next(new errors.Forbidden('Wrong registration key.'));
  }
  let newUser = new User({ username: req.body.username, password: req.body.password, presence: [], score: [] });
  newUser.save()
    .then(user => res.sendStatus(200))
    .catch(next);
});

router.post('/scores', auth.middleware, (req, res, next) => {
  if (!req.body.course || !req.body.score) return next(new errors.UnprocessableEntity('Missing course or score.'));

  let newScore = { course: req.body.course, score: req.body.score };
  User.update({ username: req.user.username }, { $push: { scores: newScore } }).exec()
    .then(user => res.sendStatus(200))
    .catch(next);
});

router.post('/presence', auth.middleware, (req, res, next) => {
  if (!req.body.location) return next(new errors.UnprocessableEntity('Missing location.'));

  let newPresence = { location: req.body.location, time: new Date() };
  User.update({ username: req.user.username }, { $push: { presence: newPresence } }).exec()
    .then(user => res.sendStatus(200))
    .catch(next);
});

router.delete('/profile', auth.middleware, (req, res, next) => {
  User.remove({ username: req.user.username }).exec()
    .then(user => res.sendStatus(200))
    .catch(next);
});

module.exports = router;
