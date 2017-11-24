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
                <div ng-init="getHistory()"></div>
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
                <input class="inpconv" type="text" ng-model="conv" placeholder="Enter your message">
                <button class="sendbutton" ng-click="send()">Kirim</button>
            </div>
        </div>
    </div>
</div>
<script>
    importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-app.js');
    importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-messaging.js');
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

        $scope.token = 'aaa';
        $scope.from = 'crahels';
        $scope.to = 'rayandrew';

        $scope.usernamepassenger = "";
        $scope.loadTime = 10000;

        $scope.findorderurl = 'https://jrr-chat.herokuapp.com/history/rayandrew';
        $scope.cancelfindorderurl = 'https://jrr-chat.herokuapp.com/history/rayandrew';
        $scope.checkorderurl = 'https://jrr-chat.herokuapp.com/history/rayandrew';
        $scope.historypassenger = 'https://jrr-chat.herokuapp.com/history/crahels';
        $scope.historydriver = 'https://jrr-chat.herokuapp.com/history/rayandrew';
        $scope.savechat = 'https://jrr-chat.herokuapp.com/sendchat';
        $scope.sendtokenurl = '';

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
        }

        $scope.findOrder = function() {
            // harus diganti jadi post
            $http.get($scope.findorderurl, {token: $scope.token, username: $scope.from})
                .then(function(response) {
                    console.log(response.data);
                    $scope.findorder = 0;
                    $scope.findingorder = 1;
                }, function(response) {
                    console.log("unable to perform get request");
                });
        }

        $scope.cancelFindOrder = function() {
            // harus diganti jadi post
            $http.get($scope.cancelfindorderurl, {token: $scope.token, username: $scope.from})
                .then(function(response) {
                    console.log(response.data);
                    if (!$scope.checkordersuccess) {
                        $scope.cancelorder = 1;
                        $scope.findingorder = 0;
                        $scope.findorder = 1;
                    }
                }, function(response) {
                    console.log("unable to perform get request");
                });
        }

        $scope.checkOrder = function() {
            // harus diganti jadi post dan di uncomment
            $http.get($scope.checkorderurl, {token: $scope.token, username: $scope.from})
                .then(function(response) {
                    console.log(response.data);
                    if (!$scope.cancelorder) {
                        if (response.data.orderedBy != null) {
                            $scope.checkordersuccess = 1;
                            $scope.usernamepassenger = "udah ada";
                            $scope.usernamepassenger = response.data.orderedBy;
                            $scope.findingorder = 0;
                            $scope.gotorder = 1;
                        } else {
                            $scope.nextLoad();
                        }
                    }
                }, function(response) {
                    console.log("unable to perform get request");
                    if (!$scope.cancelorder) {
                        $scope.nextLoad();
                    }
                });
        }

        $scope.getHistory = function() {
            // harus diganti jadi post
            $http.get($scope.historypassenger,{myself: $scope.from, other: $scope.to, token: $scope.token})
                .then(function(response) {
                    $scope.chathistory = response.data.data;
                    $http.get($scope.historydriver, {myself: $scope.from, other: $scope.to, token: $scope.token})
                        .then(function(res) {
                            res.data.data.map(function(val) {
                                $scope.chathistory.push(val);
                            });
                        }, function(res) {
                            console.log("Unable to perform get request");
                        });
                }, function(response) {
                    console.log("Unable to perform get request");
                });
        };

        $scope.cancelNextLoad = function() {
            $timeout.cancel($scope.loadPromise);
        };

        $scope.nextLoad = function() {
            $scope.cancelNextLoad();
            $scope.loadPromise = $timeout($scope.checkOrder(),$scope.loadTime);
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

        $scope.appendMessage = function(payload) {
            $scope.appendmsg = JSON.stringify(payload, null, 2);
            console.log('Message to be append: ');
            console.log($scope.appendmsg);
            // $scope.chathistory.push(payload);
        };

        messaging.onMessage(function(payload) {
            console.log('Message received.', payload);
            $scope.appendMessage(payload);
        });

        $scope.setTokenSentToServer = function(sent) {
            $scope.tokensent = sent;
        }

        $scope.sendTokenToServer = function(currentToken) {
            if (!$scope.tokensent) {
                console.log('Sending token to server...');
                $scope.token = currentToken;
                $http.post($scope.sendtokenurl, {username: $scope.from, token: $scope.token})
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