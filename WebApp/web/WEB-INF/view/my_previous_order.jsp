<%@ page import="com.sceptre.projek.webapp.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "history"; %>
<%! String specificPage = "customer-history"; %>
<% List<Order> orders = (List<Order>) request.getAttribute("customer_orders"); %>

<html>
<head>
    <meta charset="UTF-8">
    <title>My Previous Order - PR-OJEK</title>
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
                <img class="img-driver-pic" src="<% out.print(order.getDriverProfilePicture()); %>" alt="DRIVER PICTURE">
            </td>
            <td class="driver-history-setting">
                <form action="my_previous_order" method="post">
                    <input class="button-hide right" id="hide" type="submit" value="HIDE">
                    <input type="hidden" name="order_id" value="<% out.print(order.getId()); %>">
                    <input type="hidden" name="method" value="PUT">
                </form>
                <p class="light-grey font-15"><% out.print(order.getDate()); %></p>
                <p class="name-history"><% out.print(order.getDriverName()); %></p>
                <div class="history-details">
                    <p><% out.print(order.getPickingPoint()); %>&#x2192;<% out.print(order.getDestination()); %></p>
                    <p>You rated:&emsp;<span class="orange">
                        <% for (int j=0; j < order.getRating(); j++) { %>
                        &#10025;
                        <% } %>
                    </span></p>
                    <p>You commented:</p>
                    <p><% out.print(order.getComment()); %></p>
                </div>
            </td>
        </tr>
    </table>
    <% } %>
</div>
</body>
</html>

