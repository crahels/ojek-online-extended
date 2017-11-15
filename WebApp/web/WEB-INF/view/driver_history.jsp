<%@ page import="com.sceptre.projek.webapp.model.User" %>
<%@ page import="com.sceptre.projek.webapp.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="com.sceptre.projek.webapp.webservices.UserWS" %>
<%@ page import="com.sceptre.projek.webapp.webservices.WSClient" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "history"; %>
<%! String specificPage = "driver-history"; %>
<% List<Order> orders = (List<Order>) request.getAttribute("driver_orders"); %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Driver History - PR-OJEK</title>
    <link rel="stylesheet" type="text/css" href="../../assets/css/style.css">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>

<%@ include file="header.jsp" %>

<body>
<div class="container">
    <%@ include file="history_header.jsp" %>
    <% for (Order order : orders) { %>
    <table class="table-select-driver margin-driver-history">
        <tr>
            <td>
                <img class="img-driver-pic" src="<% out.print(order.getCustomerProfilePicture()); %>" alt="CUSTOMER PICTURE">
            </td>
            <td class="driver-history-setting">
                <form action="driver_history" method="post">
                    <input class="button-hide right" id="hide" type="submit" value="HIDE">
                    <input type="hidden" name="order_id" value="<% out.print(order.getId()); %>">
                    <input type="hidden" name="method" value="PUT">
                </form>
                <p class="light-grey font-15"><% out.print(order.getDate()); %></p>
                <p class="name-history"><% out.print(order.getCustomerName()); %></p>
                <div class="history-details">
                    <p><% out.print(order.getPickingPoint()); %>&#x2192;<% out.print(order.getDestination()); %></p>
                    <p>gave <span class="orange font-16"> <% out.print(order.getRating()); %> </span> stars for this order</p>
                    <p>and left comment:</p>
                    <p><% out.print(order.getComment()); %></p>
                </div>
            </td>
        </tr>
    </table>
    <% } %>
</div>
</body>
</html>

