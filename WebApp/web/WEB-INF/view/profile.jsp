<%@ page import="com.sceptre.projek.webapp.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "profile"; %>
<% User user = (User) request.getAttribute("user"); %>

<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>

<%@ include file="header.jsp" %>

<body>
    <div class="container">
        <h2>My Profile
            <a class="pencil orange right" href="edit_profile"></a>
        </h2>
        <img class="img-circle" src="<% out.print(user.getProfilePicture()); %>" alt="Your Profile Picture">
        <div class="user-info text-center">
            <div class="username">
                @<% out.print(user.getUsername()); %>
            </div>

            <div class="user-details">
                <% out.print(user.getName()); %> <br/>
                <% if(user.isDriver()) { %>
                Driver | <span class="text-small orange">&#9734;</span> <span class="orange"> <% out.print(String.format("%.1f", user.getRatings())); %> </span> (<% out.print(user.getVotes()); %>
                    <% if (user.getVotes() > 1) { %>
                     votes)
                    <% } else { %>
                     vote)
                    <% } %>
                <% } else { %>
                Non-Driver
                <% } %> <br/>
                <span class="text-small">&#9993;</span> <% out.print(user.getEmail()); %> <br/>
                <span class="text-small">&#9743;</span> <% out.print(user.getPhoneNumber()); %>
            </div>
        </div>
        <% if (user.isDriver()) { %>
        <h3>
        Preferred Locations:
        <a class="pencil orange text-large right" href="edit_preferred_location"></a>
        </h3>

        <div class="preferred-location-list">
            <% for (String preferredLocation: user.getPreferredLocations()) { %>
                <ul> <% out.print(preferredLocation); %>
            <% } %>
            <% for (String preferredLocation: user.getPreferredLocations()) { %>
                </ul>
            <% } %>
        </div>
        <% } %>
    </div>
</body>
</html>
