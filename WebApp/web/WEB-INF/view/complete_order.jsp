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
</head>

<%@ include file="header.jsp" %>

<body>
    <div class="container">
        <%@ include file="order_header.jsp" %>
        <h3>How Was It?</h3>
        <img src="<% out.print(driver.getProfilePicture()); %>" class="img-circle" alt="DRIVER PICTURE">
        <p class="username-driver">@<% out.print(driver.getUsername()); %></p>
        <p class="name-driver"><% out.print(driver.getName()); %></p>

        <form action="complete_order" method="post" onsubmit="return validateCompleteOrder()">
            <input type="hidden" id="picking_point" name="picking_point" value=<% out.print(request.getParameter("picking_point")); %> >
            <input type="hidden" id="destination" name="destination" value=<% out.print(request.getParameter("destination")); %> >
            <input type="hidden" id="driver_id" name="driver_id" value=<% out.print(request.getParameter("driver_id")); %> >
            <div class="stars">
                <input class="stars star-5" id="star-5" type="radio" name="star" value=5>
                <label class="stars star-5" for="star-5"></label>
                <input class="stars star-4" id="star-4" type="radio" name="star" value=4>
                <label class="stars star-4" for="star-4"></label>
                <input class="stars star-3" id="star-3" type="radio" name="star" value=3>
                <label class="stars star-3" for="star-3"></label>
                <input class="stars star-2" id="star-2" type="radio" name="star" value=2>
                <label class="stars star-2" for="star-2"></label>
                <input class="stars star-1" id="star-1" type="radio" name="star" value=1>
                <label class="stars star-1" for="star-1"></label>
            </div>

            <div class="form-comment">
                <textarea rows="2" cols ="72" id="comment" name="comment" placeholder="Your comment..."></textarea>
                <input class="button-comment right" type="submit" value="COMPLETE ORDER">
            </div>
        </form>
    </div>

    <script type="text/javascript" src="../../assets/js/order_validation.js"></script>
</body>
