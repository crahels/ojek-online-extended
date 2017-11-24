<%@ page import="com.sceptre.projek.webapp.model.User" %>
<%--
  Created by IntelliJ IDEA.
  User: nim_13515124
  Date: 11/20/17
  Time: 8:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "order"; %>
<%! String currentSubPage = "chat_passenger"; %>
<% String picking_point = request.getParameter("picking_point"); %>
<% String destination = request.getParameter("destination"); %>
<% String tokenFCM = request.getParameter("tokenFCM"); %>
<% String driverId = request.getParameter("driver_id"); %>
<% String preferred_driver = request.getParameter("preferred_driver"); %>

<html>
<head>
    <meta charset="utf-8">
    <title>Order - Complete Order - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-animate.js"></script>
</head>

<%@ include file="header.jsp" %>

<body>
    <div class="container">
        <input type="hidden" ng-model="from" value="<%= request.getSession().getAttribute("username").toString() %>">
        <input type="hidden" ng-model="token" value="<%= request.getSession().getAttribute("access_token").toString() %>">
        <input type="hidden" ng-model="tokenFCM" value="<%= tokenFCM %>">
        <input type="hidden" ng-model="picking_point" value="<%= picking_point %>">
        <input type="hidden" ng-model="destination" value="<%= destination %>">
        <input type="hidden" ng-model="id" value="<%= driverId %>">
        <input type="hidden" ng-model="preferred_driver" value="<%= preferred_driver %>">

        <%@ include file="order_header.jsp" %>
        <div ng-app="chatApp" ng-init="getHistory()" ng-controller="chatShow">
            <div id="containerchat">
                <div class="chat" ng-repeat="conversation in chathistory | orderBy:'timestamp'">
                    <div ng-if="conversation.from  === 'crahels'">
                        <div ng-init="goToBottom()" class="chatsender">{{conversation.message}}</div>
                    </div>
                    <div ng-if="conversation.to === 'crahels'">
                        <div ng-init="goToBottom()" class="chatreceiver">{{conversation.message}}</div>
                    </div>
                </div>
                <div id="endofchat"></div>
            </div>
            <div class="containerinput">
                <input class="inpconv" type="text" ng-model="conv" placeholder="Enter your message">
                <button class="sendbutton" ng-click="send()">Kirim</button>
            </div>
            <button ng-click="completeOrder()" class="closebutton">CLOSE</button>
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

        var app = angular.module('chatApp', []);

        app.controller('chatShow', function($scope, $http, $location, $anchorScroll, $timeout) {
            $scope.chathistory = [];

            $scope.to = "";
            $scope.tokensent = false;

            $scope.history = 'http//localhost:8003/api/history';
            $scope.savechat = 'http://localhost:8003/api/sendchat';
            $scope.updatetokenurl = 'http://localhost:8003/api/updatetoken';

            $scope.send = function() {
                if ($scope.conv != null && $scope.conv != "") {
                    $http.post($scope.savechat, {from: $scope.from, to: $scope.to, message: $scope.conv, token: $scope.token})
                    .then(function(response) {
                        console.log(response.data);
                        $scope.chathistory.push(response.data);
                        $scope.conv = "";
                    }, function(response) {
                        console.log("unable to perform post request");
                    });
                } else {
                    alert('Input cannot be blank.');
                }
            };

            $scope.goToBottom = function() {
                $location.hash('endofchat');
                $anchorScroll();
            };

            $scope.getHistory = function() {
                $http.post($scope.history, {from: $scope.from, to: $scope.to, token: $scope.token})
                    .then(function(response) {
                        $scope.chathistory = response.data;
                        $http.post($scope.history, {from: $scope.to, to: $scope.from, token: $scope.token})
                            .then(function(res) {
                                res.data.map(function(val) {
                                    $scope.chathistory.push(val);
                                });
                            }, function(res) {
                                console.log("Unable to perform post request");
                            });
                    }, function(response) {
                        console.log("Unable to perform post request");
                    });
            };

            $scope.completeOrder = function() {
                $location.url("http://localhost:8000/complete_order?picking_point=" + $scope.picking_point + "&destination=" + $scope.destination + "&preferred_driver=" + $scope.preferred_driver + "&driver_id=" + $scope.id + "&tokenFCM=" + $scope.tokenFCM);
            }

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

            messaging.onMessage(function(payload) {
                console.log('Message received.', payload);
                $scope.appendMessage(payload);
            });

            $scope.appendMessage = function(payload) {
                $scope.appendmsg = JSON.stringify(payload, null, 2);
                console.log('Message to be append: ');
                console.log($scope.appendmsg);
                $scope.chathistory.push(payload);
                $scope.appendmsg.data.map(function(val) {
                    $scope.chathistory.push(Object.assign({}, val, { from: $scope.from }));
                });
            };

            $scope.setTokenSentToServer = function(sent) {
                $scope.tokensent = sent;
            };

            $scope.sendTokenToServer = function(currentToken) {
                if (!$scope.tokensent) {
                    console.log('Sending token to server...');
                    $scope.tokenFCM = currentToken;
                    $http.post($scope.updatetokenurl, {username: $scope.from, tokenFCM: currentToken, token: $scope.token})
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
    <!--<script type="text/javascript" src="../../assets/js/order_validation.js"></script>-->
</body>
</html>
