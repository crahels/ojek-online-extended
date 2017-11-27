<%@ page import="com.sceptre.projek.webapp.model.User" %><%--
  Created by IntelliJ IDEA.
  User: Jordhy
  Date: 11/6/2017
  Time: 10:57 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "order"; %>
<%! String currentSubPage = "complete_order"; %>
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
    <div class="container" ng-app="completeOrderApp" ng-controller="completeOrder">
        <%@ include file="order_header.jsp" %>
        <h3>How Was It?</h3>
        <img src="<%= driver.getProfilePicture() %>" class="img-circle" alt="DRIVER PICTURE">
        <p class="username-driver">@<%= driver.getUsername() %></p>
        <p class="name-driver"><%= driver.getName() %></p>

        <form method="post" onsubmit="return validateCompleteOrder()">
            <input type="hidden" id="from" value="<%= request.getSession().getAttribute("username").toString() %>">
            <input type="hidden" id="token" value="<%= request.getSession().getAttribute("access_token").toString() %>">
            <input type="hidden" id="picking_point" name="picking_point" value="<%= request.getParameter("picking_point") %>" >
            <input type="hidden" id="destination" name="destination" value="<%= request.getParameter("destination") %>" >
            <input type="hidden" id="driver_id" name="driver_id" value="<%= request.getParameter("driver_id") %>" >
            <input type="hidden" id="driver_username" value="<%= driver.getUsername() %>">
            <div class="stars">
                <input ng-click="changeStar(5)" class="stars star-5" id="star-5" type="radio" name="star" value=5>
                <label class="stars star-5" for="star-5"></label>
                <input ng-click="changeStar(4)" class="stars star-4" id="star-4" type="radio" name="star" value=4>
                <label class="stars star-4" for="star-4"></label>
                <input ng-click="changeStar(3)" class="stars star-3" id="star-3" type="radio" name="star" value=3>
                <label class="stars star-3" for="star-3"></label>
                <input ng-click="changeStar(2)" class="stars star-2" id="star-2" type="radio" name="star" value=2>
                <label class="stars star-2" for="star-2"></label>
                <input ng-click="changeStar(1)" class="stars star-1" id="star-1" type="radio" name="star" value=1>
                <label class="stars star-1" for="star-1"></label>
            </div>

            <div class="form-comment">
                <textarea rows="2" cols ="72" id="comment" name="comment" placeholder="Your comment..."></textarea>
                <input class="button-comment right" ng-click="endOrder()" type="submit" value="COMPLETE ORDER">
            </div>
        </form>
    </div>

    <script type="text/javascript" src="../../assets/js/order_validation.js"></script>
</body>

<script>
    var app = angular.module('completeOrderApp', []);

    app.controller('completeOrder', function($scope, $http, $location, $anchorScroll, $timeout) {
        $scope.star = 0;
        $scope.comment = '';
        $scope.endorder = "http://localhost:8003/api/endorder"

        $scope.from = document.getElementById("from").value;
        $scope.token = document.getElementById("token").value;
        $scope.picking_point = document.getElementById("picking_point").value;
        $scope.destination = document.getElementById("destination").value;
        $scope.driver_id = document.getElementById("driver_id").value;
        $scope.driver_username = document.getElementById("driver_username").value;
        $scope.comment = document.getElementById("comment").value;

        $scope.changeStar = function(star) {
            $scope.star = star;
        };

        $scope.endOrder = function() {
            $http.post($scope.endorder,{username: $scope.from, driver: $scope.driver_username, token: $scope.token})
                .then(function(response) {
                    $scope.chathistory = response.data;
                    $http({
                        method: 'POST',
                        url: 'http://localhost:8000/complete_order',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        transformRequest: function(obj) {
                            var str = [];
                            for(var p in obj)
                                str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
                            return str.join("&");
                        },
                        data: {picking_point: $scope.picking_point, destination: $scope.destination, driver_id: $scope.driver_id, star: $scope.star, comment: $scope.comment}
                    }).then(function(res) {
                        window.location.href = 'http://localhost:8000/order'
                        return true;
                    }, function(res) {
                        console.log("Unable to perform post request");
                    })
                }, function(response) {
                    console.log("Unable to perform post request");
                });
        };
    });
</script>
