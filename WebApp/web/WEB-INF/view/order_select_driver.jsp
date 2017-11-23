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
<% String picking_point = request.getParameter("picking_point"); %>
<% String destination = request.getParameter("destination"); %>
<% String preferred_driver = request.getParameter("preferred_driver"); %>

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
    <div class="container dark-grey" ng-app = "selectDriverApp" ng-controller="showDrivers">
        <%@ include file="order_header.jsp" %>
        <div class="select-driver-border" ng-init="getPreferredDrivers()">
            <h1>Preferred Drivers:</h1>
            <div ng-repeat = "driver in arrpreferreddriver">
                <table class="table-select-driver">
                    <tr>
                        <td>
                            <img class="img-driver-pic" ng-src="{{driver.profilepicture}}" alt="DRIVER PICTURE">
                        </td>
                        <td>
                            <p class="driver-name">{{driver.name}}</p>
                            <p class="star"><span class="orange">&#10025; {{driver.rating}} </span> ({{driver.votes}}
                                <div ng-if="driver.votes > 1">
                                    votes)
                                </div>
                                <div ng-if="driver.votes <= 1">
                                    vote)
                                </div>
                            </p>
                            <a href="complete_order?picking_point=<% out.print(picking_point); %>&destination=<% out.print(destination); %>&preferred_driver=<% out.print(preferred_driver); %>&driver_id= "> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
                        </td>
                    </tr>
                </table>
            <%  }
            } else { %>
                <p class="align-center nothing-to-display-margin">Nothing to display :(</p>
            <% } %>

        </div>

        <div class="select-driver-border dark-grey" ng-init="getOtherDrivers()">
            <h1>Other Drivers:</h1>
            <% if (!otherDrivers.isEmpty()) {
                for (User otherDriver : otherDrivers) { %>
            <table class="table-select-driver">
                <tr>
                    <td>
                        <img class="img-driver-pic" src="<% out.print(otherDriver.getProfilePicture()); %>" alt="DRIVER PICTURE">
                    </td>
                    <td>
                        <p class="driver-name"> <% out.print(otherDriver.getName()); %> </p>
                        <p class="star"><span class="orange">&#10025; <% out.print(String.format("%.1f", otherDriver.getRatings())); %> </span> (<% out.print(otherDriver.getVotes()); %>
                            <% if (otherDriver.getVotes()> 1) { %>
                            votes)
                            <% } else { %>
                            vote)
                            <% } %>
                        </p>
                        <a href="complete_order?picking_point=<% out.print(request.getParameter("picking_point")); %>&destination=<% out.print(request.getParameter("destination")); %>&preferred_driver=<% out.print(request.getParameter("preferred_driver")); %>&driver_id=<% out.print(otherDriver.getId()); %> "> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
                    </td>
                </tr>
            </table>
            <%  }
            } else { %>
            <p class="align-center nothing-to-display-margin">Nothing to display :(</p>
            <% } %>
        </div>
    </div>
<%--
<div class="select-driver-border">
            <h1>Preferred Drivers:</h1>
            <% if (!preferredDrivers.isEmpty()) {
                for (User preferredDriver : preferredDrivers) { %>
                <table class="table-select-driver">
                    <tr>
                        <td>
                            <img class="img-driver-pic" src="<% out.print(preferredDriver.getProfilePicture()); %>" alt="DRIVER PICTURE">
                        </td>
                        <td>
                            <p class="driver-name"> <% out.print(preferredDriver.getName()); %> </p>
                            <p class="star"><span class="orange">&#10025; <% out.print(String.format("%.1f", preferredDriver.getRatings())); %> </span> (<% out.print(preferredDriver.getVotes()); %>
                        <% if (preferredDriver.getVotes()> 1) { %>
                                 votes)
                        <% } else { %>
                                 vote)
                        <% } %>
                            </p>
                            <a href="complete_order?picking_point=<% out.print(request.getParameter("picking_point")); %>&destination=<% out.print(request.getParameter("destination")); %>&preferred_driver=<% out.print(request.getParameter("preferred_driver")); %>&driver_id=<% out.print(preferredDriver.getId()); %> "> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
                        </td>
                    </tr>
                </table>
            <%  }
            } else { %>
                <p class="align-center nothing-to-display-margin">Nothing to display :(</p>
            <% } %>
        </div>
--%>
    <%--<div class="select-driver-border dark-grey">
                <h1>Other Drivers:</h1>
                <% if (!otherDrivers.isEmpty()) {
                    for (User otherDriver : otherDrivers) { %>
                <table class="table-select-driver">
                    <tr>
                        <td>
                            <img class="img-driver-pic" src="<% out.print(otherDriver.getProfilePicture()); %>" alt="DRIVER PICTURE">
                        </td>
                        <td>
                            <p class="driver-name"> <% out.print(otherDriver.getName()); %> </p>
                            <p class="star"><span class="orange">&#10025; <% out.print(String.format("%.1f", otherDriver.getRatings())); %> </span> (<% out.print(otherDriver.getVotes()); %>
                                <% if (otherDriver.getVotes()> 1) { %>
                                votes)
                                <% } else { %>
                                vote)
                                <% } %>
                            </p>
                            <a href="complete_order?picking_point=<% out.print(request.getParameter("picking_point")); %>&destination=<% out.print(request.getParameter("destination")); %>&preferred_driver=<% out.print(request.getParameter("preferred_driver")); %>&driver_id=<% out.print(otherDriver.getId()); %> "> <input class="button-i-choose-you right" type="button" value="I CHOOSE YOU!!"> </a>
                        </td>
                    </tr>
                </table>
                <%  }
                } else { %>
                <p class="align-center nothing-to-display-margin">Nothing to display :(</p>
                <% } %>
            </div>--%>
</body>
<script>
    var app = angular.module('selectDriverApp', []);

    app.controller('showDrivers', function($scope, $location, $anchorScroll, $http, $timeout) {
        $scope.picking_point = <% out.print(picking_point);%>;
        $scope.preferred_driver = <% out.print(preferred_driver);%>;
        $scope.destination = <% out.print(destination);%>;

        $scope.arrpreferreddriver = [];
        scope.arrotherdriver = [];
        $scope.preferreddriver = ''; // url
        $scope.otherdriver = ''; // url

        $scope.token = 'aaa';
        $scope.username = 'crahels';

        $scope.getPreferredDrivers = function() {
            $http.get($scope.preferreddriver,{username: $scope.username, picking_point: $scope.picking_point, destination: $scope.destination, preferred_driver: $scope.preferred_driver, token: $scope.token})
                .then(function(response) {
                    $scope.arrpreferreddriver = response.data;
                }, function(response) {
                    console.log("Unable to perform get request");
                });
        };

        $scope.getOtherDrivers = function() {
            $http.get($scope.otherdriver,{username: $scope.username, picking_point: $scope.picking_point, destination: $scope.destination, preferred_driver: $scope.preferred_driver, token: $scope.token})
                .then(function(response) {
                    $scope.arrotherdriver = response.data;
                }, function(response) {
                    console.log("Unable to perform get request");
                });
        }
    });
</script>
</html>
