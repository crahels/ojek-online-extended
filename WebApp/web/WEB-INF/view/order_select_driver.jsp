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
<%--<% List<User> preferredDrivers = (List<User>) request.getAttribute("preferred_drivers"); %>
<% List<User> otherDrivers = (List<User>) request.getAttribute("other_drivers"); %>--%>

<html>
<head>
    <meta charset="utf-8">
    <title>Order - Select Driver - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>

<%@ include file="header.jsp" %>

<body>
    <div class="container dark-grey" ng-app="selectDriverApp" ng-controller="selectDriver">
        <%@ include file="order_header.jsp" %>
        <div class="select-driver-border">
            <h1>Preferred Drivers:</h1>
            <div ng-if="countarrpreferred > 0">
                <div ng-repeat="driver in arrPreferredDriver">
                    <table class="table-select-driver">
                        <tr>
                            <td>
                                <img class="img-driver-pic" ng-src="{{driver.profilepicture}}" alt="DRIVER PICTURE">
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
                                <a ng-href="complete_order?picking_point=<% out.print(request.getParameter("picking_point")); %>&destination=<% out.print(request.getParameter("destination")); %>&preferred_driver=<% out.print(request.getParameter("preferred_driver")); %>&driver_id={{driver.id}} "> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
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
                                <img class="img-driver-pic" ng-src="{{driver.profilepicture}}" alt="DRIVER PICTURE">
                            </td>
                            <td>
                                <p class="driver-name"> {{driver.name}} </p>
                                <p class="star"><span class="orange">&#10025; {{driver.ratings}} </span> (driver.votes
                                    <div ng-if="driver.votes > 1">
                                        votes)
                                    </div>
                                    <div ng-if="driver.votes <= 1">
                                        vote)
                                    </div>
                                </p>
                                <a ng-href="complete_order?picking_point=<% out.print(request.getParameter("picking_point")); %>&destination=<% out.print(request.getParameter("destination")); %>&preferred_driver=<% out.print(request.getParameter("preferred_driver")); %>&driver_id={{driver.id}} "> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
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
</body>
<script>
    var app = angular.module('selectDriverApp', []);

    app.controller('selectDriver', function($scope, $http, $location, $anchorScroll, $timeout) {
        $scope.pickingpoint = <% out.print(request.getParameter("picking_point")); %>;
        $scope.destination = <% out.print(request.getParameter("destination")); %>;
        $scope.preferreddriver = <% out.print(request.getParameter("preferred_driver")); %>;
        $scope.arrPreferredDriver = [];
        $scope.arrOtherDriver = [];

        $scope.username = 'crahels';
        $scope.token = 'aaa';
        $scope.countarrpreferred = 0;
        $scope.countarrother = 0;
        $scope.loadTime = 10000;

        $scope.preferreddriverurl = 'https://jrr-chat.herokuapp.com/history/crahels';
        $scope.otherdriverurl = 'https://jrr-chat.herokuapp.com/history/crahels';

        $scope.getPreferredDriver = function() {
            $http.get($scope.preferreddriverurl, {username: $scope.username, pickingpoint: $scope.pickingpoint, destination: $scope.destination, preferreddriver: $scope.preferreddriver, token: $scope.token})
                .then(function(response) {
                    console.log(response.data);
                    $scope.arrPreferredDriver = response.data;
                    $scope.countarrpreferred = response.data.length;
                    $scope.nextLoad();
                }, function(response) {
                    console.log("unable to perform get request");
                    $scope.nextLoad();
                });
        };

        $scope.getOtherDriver = function() {
            $http.get($scope.otherdriverurl, {username: $scope.username, pickingpoint: $scope.pickingpoint, destination: $scope.destination, preferreddriver: $scope.preferreddriver, token: $scope.token})
                .then(function(response) {
                    console.log(response.data);
                    $scope.arrOtherDriver = response.data;
                    $scope.countarrother = response.data.length;
                    $scope.nextLoad();
                }, function(response) {
                    console.log("unable to perform get request");
                    $scope.nextLoad();
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
    });
</script>
</html>
