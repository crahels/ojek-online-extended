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
<%! String currentSubPage = "chat_driver"; %>
<% User driver = (User) request.getAttribute("driver"); %>
<%--
    Data binding (ng-model directives)
    Controllers (ng-controllers)
    ng-repeat, untuk menampilkan list
    $http untuk AJAX request
    $scope untuk komunikasi data antara controller dengan view.
    ng-show dan ng-hide untuk menampilkan/menyembunyikan elemen
--%>

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
        <div ng-app="chatApp" ng-controller="chatShow">
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
                <button class="send" ng-click="send()">Kirim</button>
            </div>
        </div>
    </div>
    <script>
        var key = 0;
        var app = angular.module('chatApp', []);

        app.controller('chatShow', function($scope) {
            $scope.chathistory = [];
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
        });
    </script>
    <!--<script type="text/javascript" src="../../assets/js/order_validation.js"></script>-->
</body>
</html>
