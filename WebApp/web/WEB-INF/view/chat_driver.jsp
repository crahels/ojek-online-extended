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
    <div ng-app="chatApp" ng-controller="chatShow">
        <div ng-show="findorder">
            <button class="find-order-button" ng-click="findOrder()">FIND ORDER</button>
        </div>
        <div ng-show="!findorder">
            <div class="finding-order"><span class="bold">Finding Order...</span></div>
            <button class="cancel-order-button">CANCEL</button>
        </div>
        <div ng-show="!findorder">
            <div class="header-driver"><span class="bold">Got an Order!</span></div>
            <div class="username-order"><span class="bold">ini harusnya username</span></div>
            <div id="containerchat">
                <div class="chat" ng-repeat="(key,value) in chathistory">
                    <div ng-if="key % 2 == 0">
                        <div ng-init="goToBottom('containerchat')" class="chatsender">{{value[key]}}</div>
                    </div>
                    <div ng-if="key % 2 == 1">
                        <div ng-init="goToBottom('containerchat')" class="chatreceiver">{{value[key]}}</div>
                    </div>
                </div>
            </div>
            <div class="containerinput">
                <input class="inpconv" type="text" ng-model="conv" placeholder="Enter your message">
                <button class="sendbutton" ng-click="send()">Kirim</button>
            </div>
        </div>
    </div>
</div>
<script>
    var key = 0;
    var app = angular.module('chatApp', []);

    app.controller('chatShow', function($scope) {
        $scope.chathistory = [];
        $scope.findorder = 1;
        $scope.send = function() {
            if ($scope.conv != null && $scope.conv != "") {
                var parts = {};
                parts[key] = $scope.conv;
                key++;

                $scope.chathistory.push(parts);
                $scope.conv = "";
            } else {
                alert('Input cannot be blank.');
            }
        }
        $scope.goToBottom = function(id) {
            var scroller = document.getElementById(id);
            scroller.scrollTop = scroller.scrollHeight;
        }
        $scope.findOrder = function() {
            $scope.findorder = 0;
        }
    });
</script>
</body>
</html>