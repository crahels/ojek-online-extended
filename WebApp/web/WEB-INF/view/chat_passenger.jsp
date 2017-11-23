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
<% User driver = (User) request.getAttribute("driver"); %>

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
            <button class="closebutton">CLOSE</button>
        </div>
    </div>
    <!--<script>
        importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-app.js');
        importScripts('https://www.gstatic.com/firebasejs/3.9.0/firebase-messaging.js');
    </script>-->
    <script>
        var key = 0;
        var app = angular.module('chatApp', []);

        app
        .controller('chatShow', function($scope, $http, $location, $anchorScroll, $timeout) {
            $scope.chathistory = [];
            $scope.historypassenger = 'https://jrr-chat.herokuapp.com/history/crahels';
            $scope.historydriver = 'https://jrr-chat.herokuapp.com/history/rayandrew';
            $scope.savechat = 'https://jrr-chat.herokuapp.com/sendchat';
            $scope.loadTime = 10000;

            $scope.send = function() {
                if ($scope.conv != null && $scope.conv != "") {
                    $http.post($scope.savechat, {from: 'crahels', to: 'rayandrew', message: $scope.conv, token: 'aaa'})
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
                $http.get($scope.historypassenger)
                    .then(function(response) {
                        $scope.chathistory = response.data.data;
                        $http.get($scope.historydriver)
                            .then(function(res) {
                                res.data.data.map(function(val) {
                                    $scope.chathistory.push(val);
                                });
                                $scope.nextLoad();
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
                $scope.loadPromise = $timeout($scope.getHistory(),$scope.loadTime);
            }

            $scope.$on('$destroy', function() {
                $scope.cancelNextLoad();
            });


        });
    </script>
    <!--<script type="text/javascript" src="../../assets/js/order_validation.js"></script>-->
</body>
</html>
