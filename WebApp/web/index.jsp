<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%
    // New location to be redirected
    if (request.getSession().getAttribute("access_token") != null) {
        response.sendRedirect("profile");
    } else {
        response.sendRedirect("login");
    }
  %>
