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
<% String driver = request.getParameter("driver");%>

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
        <input type="hidden" id="from" value="<%= request.getSession().getAttribute("username").toString() %>">
        <input type="hidden" id="token" value="<%= request.getSession().getAttribute("access_token").toString() %>">
        <input type="hidden" id="tokenFCM" value="<%= tokenFCM %>">
        <input type="hidden" id="picking_point" value="<%= picking_point %>">
        <input type="hidden" id="destination" value="<%= destination %>">
        <input type="hidden" id="id" value="<%= driverId %>">
        <input type="hidden" id="preferred_driver" value="<%= preferred_driver %>">
        <input type="hidden" id="driver" value="<%= driver %>">

        <%@ include file="order_header.jsp" %>
        <div ng-app="chatApp" ng-controller="chatShow" ng-init="requestPermission()">
            <div id="containerchat" ng-init="getHistory()">
                <div class="chat" ng-repeat="conversation in chathistory | orderBy:'timestamp'">
                    <div ng-if="conversation.from  === from">
                        <div ng-init="goToBottom()" class="chatsender">{{conversation.message}}</div>
                    </div>
                    <div ng-if="conversation.to === from">
                        <div ng-init="goToBottom()" class="chatreceiver">{{conversation.message}}</div>
                    </div>
                </div>
                <div id="endofchat"></div>
            </div>
            <div class="containerinput">
                <input class="inpconv" type="text" id="conv" placeholder="Enter your message">
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

        app.controller('chatShow', function($scope, $http, $location, $anchorScroll) {
            const messaging = firebase.messaging();

            $scope.chathistory = [];
            $scope.from = document.getElementById("from").value;
            $scope.token = document.getElementById("token").value;
            $scope.tokenFCM = document.getElementById("tokenFCM").value;
            $scope.picking_point = document.getElementById("picking_point").value;
            $scope.destination = document.getElementById("destination").value;
            $scope.id = document.getElementById("id").value;
            $scope.preferred_driver = document.getElementById("preferred_driver").value;

            $scope.to = document.getElementById("driver").value;
            $scope.tokensent = false;

            $scope.history = 'http://localhost:8003/api/history';
            $scope.savechat = 'http://localhost:8003/api/sendchat';
            $scope.updatetokenurl = 'http://localhost:8003/api/updatetoken';

            $scope.send = function() {
                $scope.conv = document.getElementById("conv").value;
                if ($scope.conv !== null && $scope.conv !== "") {
                    $http.post($scope.savechat, { username: $scope.from, from: $scope.from, to: $scope.to, message: $scope.conv, token: $scope.token })
                    .then(function(response) {
                        // console.log(response.data);
                        $scope.chathistory.push(response.data);
                        document.getElementById("conv").value = "";
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
                $http.post($scope.history, {username: $scope.from, from: $scope.from, to: $scope.to, token: $scope.token})
                    .then(function(response) {
                        $scope.chathistory = response.data;
                        $http.post($scope.history, {username: $scope.from, to: $scope.from, from: $scope.to, token: $scope.token})
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

            $scope.$on('$destroy', function() {
                $scope.cancelNextLoadEndOrder();
            });

            $scope.completeOrder = function() {
                window.location.href = "http://localhost:8000/complete_order?picking_point=" + $scope.picking_point + "&destination=" + $scope.destination + "&preferred_driver=" + $scope.preferred_driver + "&driver_id=" + $scope.id + "&tokenFCM=" + $scope.tokenFCM;
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
                console.log('Message received.', payload.data);
                $scope.chathistory.push(Object.assign({}, payload.data, { from: $scope.to }));
                $scope.$apply();
            });

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
