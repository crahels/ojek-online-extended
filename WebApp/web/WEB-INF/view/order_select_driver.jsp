<%--
  Created by IntelliJ IDEA.
  User: Jordhy
  Date: 11/6/2017
  Time: 7:16 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="com.sceptre.projek.webapp.model.User" %>
<%@ page import="java.util.List" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "order"; %>
<%! String currentSubPage = "select_driver"; %>
<%
    String pDrivers = request.getAttribute("preferred_drivers").toString();
    String oDrivers = request.getAttribute("other_drivers").toString();
%>

<html>
<head>
    <meta charset="utf-8">
    <title>Order - Select Driver - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-animate.js"></script>
</head>

<%@ include file="header.jsp" %>

<body>
    <input type="hidden" id="preferred" value='<%= pDrivers %>'>
    <input type="hidden" id="other" value='<%= oDrivers %>'>
    <input type="hidden" id="token" value="<%= request.getSession().getAttribute("access_token").toString() %>">
    <input type="hidden" id="username" value="<%= request.getSession().getAttribute("username").toString() %>">
    <input type="hidden" id="picking_point" value="<%= request.getParameter("picking_point") %>">
    <input type="hidden" id="destination" value="<%= request.getParameter("destination") %>">
    <input type="hidden" id="preferred_driver" value="<%= request.getParameter("preferred_driver") %>">
    <div class="container dark-grey" ng-app="selectDriverApp" ng-controller="selectDriver" ng-init="requestPermission()">
        <%@ include file="order_header.jsp" %>
        <div class="select-driver-border" ng-init="getDriver()">
            <h1>Preferred Drivers:</h1>
            <div ng-if="countarrpreferred > 0">
                <div ng-repeat="driver in arrPreferredDriver">
                    <table class="table-select-driver">
                        <tr>
                            <td>
                                <img class="img-driver-pic" ng-src="{{driver.profile_picture}}" alt="DRIVER PICTURE">
                            </td>
                            <td>
                                <p class="driver-name"> {{driver.name}} </p>
                                <p class="star"><span class="orange">&#10025; {{driver.ratings}} </span> ({{driver.votes}}
                                    <div ng-if="driver.votes > 1">
                                        votes)
                                    </div>
                                    <div ng-if="driver.votes <= 1">
                                        vote)
                                    </div>
                                </p>
                                <a ng-click="startOrder(driver.username, driver.id)"> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div ng-if="countarrpreferred === 0">
                <p class="align-center nothing-to-display-margin">Nothing to display :(</p>
            </div>
        </div>

        <div class="select-driver-border dark-grey">
            <h1>Other Drivers:</h1>
            <div ng-if="countarrother > 0">
                <div ng-repeat="driver in arrOtherDriver">
                    <table class="table-select-driver">
                        <tr>
                            <td>
                                <img class="img-driver-pic" ng-src="{{driver.profile_picture}}" alt="DRIVER PICTURE" />
                            </td>
                            <td>
                                <p class="driver-name"> {{driver.name}} </p>
                                <p class="star"><span class="orange">&#10025; {{driver.ratings}} </span> ({{driver.votes}}
                                    <span ng-if="driver.votes > 1">
                                        votes)
                                    </span>
                                    <span ng-if="driver.votes <= 1">
                                        vote)
                                    </span>
                                </p>
                                <a ng-click="startOrder(driver.username, driver.id)"> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div ng-if="countarrother === 0">
                <p class="align-center nothing-to-display-margin">Nothing to display :(</p>
            </div>
        </div>
    </div>
    <script src="https://www.gstatic.com/firebasejs/3.9.0/firebase.js"></script>
    <script src="https://www.gstatic.com/firebasejs/3.9.0/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/3.9.0/firebase-auth.js"></script>
    <script src="https://www.gstatic.com/firebasejs/3.9.0/firebase-messaging.js"></script>
    <link rel="manifest" href="manifest.json">
    <script>
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('firebase-messaging-sw.js').then(function(registration) {
                // Registration was successful
                console.log('ServiceWorker registration successful with scope: ', registration.scope);
            }).catch(function(err) {
                // registration failed :(
                console.log('ServiceWorker registration failed: ', err);
            });
        }

        var config = {
            apiKey: "AIzaSyBtisuPgPCI8Z54LrY9EhiMs1rfEb_mAXA",
            authDomain: "tubes-3-wbd-c0ef6.firebaseapp.com",
            databaseURL: "https://tubes-3-wbd-c0ef6.firebaseio.com",
            projectId: "tubes-3-wbd-c0ef6",
            storageBucket: "tubes-3-wbd-c0ef6.appspot.com",
            messagingSenderId: "585220599787"
        };
        firebase.initializeApp(config);

        var app = angular.module('selectDriverApp', []);

        app.controller('selectDriver', function($scope, $http, $location, $anchorScroll, $timeout) {
            const messaging = firebase.messaging();

            $scope.arrPreferredDriver = [];
            $scope.arrOtherDriver = [];

            $scope.countarrpreferred = 0;
            $scope.countarrother = 0;
            $scope.loadTime = 15000;
            $scope.tokensent = false;

            $scope.prefdriver = JSON.parse(document.getElementById("preferred").value);
            $scope.othdriver = JSON.parse(document.getElementById("other").value);
            $scope.token = document.getElementById("token").value;
            $scope.username = document.getElementById("username").value;
            $scope.picking_point = document.getElementById("picking_point").value;
            $scope.destination = document.getElementById("destination").value;
            $scope.preferred_driver = document.getElementById("preferred_driver").value;

            $scope.driverurl = 'http://localhost:8003/api/listdriver';
            $scope.startorderurl = 'http://localhost:8003/api/startchat';
            $scope.updatetokenurl = 'http://localhost:8003/api/updatetoken';

            $scope.getDriver = function() {
                var prefdriverpost = $scope.prefdriver.map(function(value) {
                    return {
                        name: value.name,
                        id: value.id,
                        votes: value.votes,
                        ratings: value.ratings,
                        username: value.username
                    };
                });

                var otherdriverpost = $scope.othdriver.map(function(value) {
                    return {
                        name: value.name,
                        id: value.id,
                        votes: value.votes,
                        ratings: value.ratings,
                        username: value.username
                    };
                });

                $http.post($scope.driverurl, {username: $scope.username, token: $scope.token, other_drivers: otherdriverpost, preferred_driver: prefdriverpost})
                    .then(function(response) {
                        $scope.arrPreferredDriver = response.data.preferred_driver.map(function(value) {
                            return Object.assign({}, value, { profile_picture : $scope.prefdriver.find(function(val) {
                                // console.log(' pref : ' + JSON.stringify(val));
                                return value.username === val.username;
                            }).profile_picture });
                        });

                        $scope.countarrpreferred = response.data.preferred_driver.length;

                        $scope.arrOtherDriver = response.data.other_drivers.map(function(value) {
                            return Object.assign({}, value, { profile_picture : $scope.othdriver.find(function(val) {
                                // console.log(' other : ' + JSON.stringify(val) + ' : ' + JSON.stringify(value));
                                return value.username === val.username;
                            }).profile_picture });
                        });

                        $scope.countarrother = response.data.other_drivers.length;

                        $scope.nextLoad();
                    }, function(response) {
                        console.log("unable to perform post request");
                        $scope.nextLoad();
                    });
            };

            $scope.startOrder = function(driver, id) {
                $scope.id = id;
                $http.post($scope.startorderurl, {username: $scope.username, token: $scope.token, tokenFCM: $scope.tokenFCM, driver: driver })
                    .then(function(response) {
                        console.log(response.data);
                        window.location.href = "http://localhost:8000/chat_passenger?driver=" + driver + "&picking_point=" + $scope.picking_point + "&destination=" + $scope.destination + "&preferred_driver=" + $scope.preferred_driver + "&driver_id=" + $scope.id + "&tokenFCM=" + $scope.tokenFCM;
                    }, function(response) {
                        console.log("unable to perform post request");
                    });
            };

            $scope.cancelNextLoad = function() {
                $timeout.cancel($scope.loadPromise);
            };

            $scope.nextLoad = function() {
                $scope.cancelNextLoad();
                $scope.loadPromise = $timeout($scope.getDriver(),$scope.loadTime);
            }

            $scope.$on('$destroy', function() {
                $scope.cancelNextLoad();
            });

            messaging.onTokenRefresh(function() {
                messaging.getToken()
                    .then(function(refreshedToken) {
                        console.log('Token refreshed.');
                        $scope.setTokenSentToServer(false);
                        $scope.sendTokenToServer(refreshedToken);
                        $scope.retrieveToken();
                    })
                    .catch(function(err) {
                        console.log('Unable to retrieve token ', err);
                    });
            });

            $scope.setTokenSentToServer = function(sent) {
                $scope.tokensent = sent;
            };

            $scope.sendTokenToServer = function(currentToken) {
                if (!$scope.tokensent) {
                    console.log('Sending token to server...');
                    $scope.tokenFCM = currentToken;
                    $http.post($scope.updatetokenurl, {username: $scope.username, tokenFCM: currentToken, token: $scope.token})
                        .then(function(response) {
                            console.log(response.data);
                            $scope.setTokenSentToServer(true);
                        }, function(response) {
                            console.log("unable to perform post request");
                        });
                } else {
                    console.log('Token already sent to server so won\'t send it again.');
                }
            };

            $scope.retrieveToken = function() {
                messaging.getToken()
                    .then(function(currentToken) {
                        if (currentToken) {
                            console.log('your token is: ');
                            console.log(currentToken);
                            $scope.sendTokenToServer(currentToken);
                        } else {
                            console.log('No Instance ID token available. Request permission to generate one.');
                            $scope.setTokenSentToServer(false);
                        }
                    })
                    .catch(function(err) {
                        console.log('An error occurred while retrieving token. ', err);
                        $scope.setTokenSentToServer(false);
                    });
            };

            $scope.requestPermission = function() {
                console.log('Requesting permission...');
                messaging.requestPermission()
                    .then(function() {
                        console.log('Notification permission granted.');
                        $scope.retrieveToken();
                    })
                    .catch(function(err) {
                        console.log('Unable to get permission to notify.', err);
                    });
            };
        });
    </script>
</body>
</html>
