package com.sceptre.projek.webapp.servlet;

import com.sceptre.projek.webapp.HttpUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Map<String, String> body = new LinkedHashMap<>();
        body.put("access_token", (String) session.getAttribute("access_token"));
        body.put("identifier", TokenValidator.getIdentifier(request));

        try {
            HttpUtils.requestPost(HttpUtils.getIdentityServiceUrl("/logout"), body);

            session.removeAttribute("access_token");
            session.removeAttribute("refresh_token");
            session.removeAttribute("expiry_time");
            session.removeAttribute("username");
            response.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            response.sendRedirect("profile");
        }
    }
}
