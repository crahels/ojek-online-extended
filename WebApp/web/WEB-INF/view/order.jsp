<%--
  Created by IntelliJ IDEA.
  User: Jordhy
  Date: 11/6/2017
  Time: 6:58 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%! String currentPage = "order"; %>
<%! String currentSubPage = "select_destination"; %>
<html>
<head>
    <meta charset="utf-8">
    <title>Order - Select Destination - PR-OJEK</title>
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link rel="shortcut icon" href="../../assets/favicon.png" type="image/x-icon">
    <link rel="icon" href="../../assets/favicon.png" type="image/x-icon">
</head>

<%@ include file="header.jsp" %>

<body>
    <div class="container">
        <%@ include file="order_header.jsp" %>
        <form action="order_select_driver" onsubmit="return validateOrder()" method="get">
            <table class="table-select_destination dark-grey">
                <tr>
                    <td>
                        <label for="picking_point">Picking point</label>
                    </td>

                    <td>
                        <input id="picking_point" type="text" name="picking_point" placeholder="Enter your picking point">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label for="destination">Destination</label>
                    </td>

                    <td>
                        <input id="destination" type="text" name="destination" placeholder="Enter your destination">
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="preferred_driver">Preferred Driver</label>
                    </td>

                    <td>
                        <input id="preferred_driver" type="text" name="preferred_driver" placeholder="(optional)">
                    </td>
                </tr>
            </table>
            <input class="button-next-order" type="submit" value="NEXT">
        </form>
    </div>

    <script type="text/javascript" src="../../assets/js/order_validation.js"></script>
</body>
</html>

