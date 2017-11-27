<%--
  Created by IntelliJ IDEA.
  User: nim_13515124
  Date: 11/22/17
  Time: 6:49 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "order"; %>

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
    <h2>Looking for an Order</h2>
    <div ng-app="chatApp" ng-controller="chatShow" ng-init="requestPermission()">
        <div ng-show="findorder">
            <button class="find-order-button" ng-click="findOrder()">FIND ORDER</button>
        </div>

        <div ng-show="findingorder">
            <div ng-if="findingorder">
                <div ng-init="checkOrder()"></div>
            </div>
            <div class="finding-order"><span class="bold">Finding Order...</span></div>
            <button class="cancel-order-button" ng-click="cancelFindOrder()">CANCEL</button>
        </div>
        <div ng-show="gotorder">
            <div ng-if="gotorder">
                <div ng-init="checkEndOrder(); getHistory();"></div>
            </div>
            <div class="header-driver"><span class="bold">Got an Order!</span></div>
            <div class="username-order"><span class="bold">{{usernamepassenger}}</span></div>
            <div id="containerchat">
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

    var app = angular.module('chatApp', []);

    app.controller('chatShow', function($scope, $location, $anchorScroll, $http, $timeout) {
        const messaging = firebase.messaging();

        $scope.chathistory = [];
        $scope.findorder = 1;
        $scope.gotorder = 0;
        $scope.findingorder = 0;
        $scope.cancelorder = 0;
        $scope.checkordersuccess = 0;
        $scope.tokensent = false;

        $scope.token = document.getElementById("token").value;
        $scope.from = document.getElementById("from").value;
        $scope.to = "";

        $scope.usernamepassenger = "";
        $scope.loadTime = 15000;

        $scope.findorderurl = 'http://localhost:8003/api/findorder';
        $scope.cancelfindorderurl = 'http://localhost:8003/api/cancelorder';
        $scope.checkorderurl = 'http://localhost:8003/api/checkorder';
        $scope.history = 'http://localhost:8003/api/history';
        $scope.savechat = 'http://localhost:8003/api/sendchat';
        $scope.updatetokenurl = 'http://localhost:8003/api/updatetoken';
        $scope.checkendorder = 'http://localhost:8003/api/checkendorder';

        $scope.send = function() {
            $scope.conv = document.getElementById("conv").value;
            if ($scope.conv !== null && $scope.conv !== "") {
                $http.post($scope.savechat, {username: $scope.from, from: $scope.from, to: $scope.to, message: $scope.conv, token: $scope.token})
                    .then(function(response) {
                        // console.log(response.data);
                        $scope.chathistory.push(response.data);
                        document.getElementById("conv").value = "";
                    }, function(response) {
                        window.location.href = "/login";
                        console.log("unable to perform post request");
                    });
            } else {
                alert('Input cannot be blank.');
            }
        };


        $scope.checkEndOrder = function() {
            $http.post($scope.checkendorder, { token: $scope.token, username: $scope.from })
                .then(function(response) {
                    // console.log(response.data);
                    if (response.data.status) {
                        window.location.href = "/profile";
                    } else {
                        $scope.nextLoadEndOrder();
                    }
                }, function(response) {
                    console.log("unable to perform post request");
                    window.location.href = "/login";
                    $scope.nextLoadEndOrder();
                });
        };

        $scope.goToBottom = function() {
            $location.hash('endofchat');
            $anchorScroll();
        };

        $scope.findOrder = function() {
            $http.post($scope.findorderurl, {token: $scope.token, username: $scope.from})
                .then(function(response) {
                    // console.log(response.data);
                    $scope.cancelorder = 0;
                    $scope.findorder = 0;
                    $scope.findingorder = 1;
                }, function(response) {
                    console.log("unable to perform post request");
                    window.location.href = "/login";
                });
        };

        $scope.cancelFindOrder = function() {
            $http.post($scope.cancelfindorderurl, {token: $scope.token, username: $scope.from})
                .then(function(response) {
                    // console.log(response.data);
                    if (!$scope.checkordersuccess) {
                        $scope.cancelorder = 1;
                        $scope.findingorder = 0;
                        $scope.findorder = 1;
                    }
                }, function(response) {
                    console.log("unable to perform post request");
                    window.location.href = "/login";
                });
        };

        $scope.checkOrder = function() {
            $http.post($scope.checkorderurl, {token: $scope.token, username: $scope.from})
                .then(function(response) {
                   // console.log(response.data);
                    if (!$scope.cancelorder) {
                        if (response.data.orderedBy) {
                            $scope.checkordersuccess = 1;
                            $scope.usernamepassenger = response.data.orderedBy;
                            $scope.to = response.data.orderedBy;
                            $scope.findingorder = 0;
                            $scope.gotorder = 1;
                        } else {
                            $scope.nextLoad();
                        }
                    }
                }, function(response) {
                    console.log("unable to perform get request");
                    window.location.href = "/login";
                    if (!$scope.cancelorder) {
                        $scope.nextLoad();
                    }
                });
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
                            window.location.href = "/login";
                        });
                }, function(response) {
                    console.log("Unable to perform post request");
                    window.location.href = "/login";
                });
        };

        $scope.cancelNextLoad = function() {
            $timeout.cancel($scope.loadPromise);
        };

        $scope.cancelNextLoadEndOrder = function() {
            $timeout.cancel($scope.loadPromiseEndOrder);
        };

        $scope.nextLoad = function() {
            $scope.cancelNextLoad();
            $scope.loadPromise = $timeout($scope.checkOrder, $scope.loadTime);
        }

        $scope.nextLoadEndOrder = function() {
            $scope.cancelNextLoadEndOrder();
            $scope.loadPromiseEndOrder = $timeout($scope.checkEndOrder, $scope.loadTime);
        };

        $scope.$on('$destroy', function() {
            $scope.cancelNextLoad();
        });

        $scope.$on('$destroy', function() {
            $scope.cancelNextLoadEndOrder();
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

        messaging.onMessage(function(payload) {
            console.log('Message received.', payload.data);
            $scope.chathistory.push(Object.assign({}, payload.data, { from: $scope.to }));
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
                        window.location.href = "/login";
                    });
            } else {
                console.log('Token already sent to server so won\'t send it again.');
            }
        };

        $scope.retrieveToken = function() {
            messaging.getToken()
                .then(function(currentToken) {
                    if (currentToken) {
                        console.log('your token: ');
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

        //$scope.requestPermission();
    });
</script>
</body>
</html>