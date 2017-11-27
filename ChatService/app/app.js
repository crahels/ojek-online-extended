'use strict';

/* Application main module */

console.log(':: ChatService ::');
console.log('NODE_ENV: %s\n', process.env.NODE_ENV);

/* Load dependencies */

const listFiles = require('fs-readdir-recursive');
const path = require('path');
const config = require('config');
const express = require('express');
const errorHandler = require('api-error-handler');

/* Create app and logger */

var app = express();
global.appDirectory = __dirname;

/* Create the logger */

const winston = require('./components/winston.js');

/* Set up Express middleware */

winston.log('verbose', 'Setting up Express middleware...');

const bodyParser = require('body-parser');
const methodOverride = require('method-override');

app.use(function (req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept'
  );
  next();
});
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(methodOverride('_method'));

/* Load and apply routes */

winston.log('verbose', 'Loading and applying routes...');

const routeDirectory = global.appDirectory;
listFiles(routeDirectory)
  .filter(file => file.endsWith('.routes.js'))
  .forEach(file => {
    const routerPath = path.join(routeDirectory, file);
    const router = require(routerPath);
    if (!router.baseRoute) router.baseRoute = '/';
    const completeRoute = config.get('routePrefix') + router.baseRoute;

    winston.log('verbose', 'Using route file %s...', file);
    app.use(completeRoute, router);
  });

/* Apply Express error handler */

app.use(errorHandler());

module.exports = app;
