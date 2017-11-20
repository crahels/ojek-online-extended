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
    </div>
    <!--<script type="text/javascript" src="../../assets/js/order_validation.js"></script>-->
</body>
</html>
