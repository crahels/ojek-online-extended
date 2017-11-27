package com.sceptre.projek.webapp.servlet;

import com.sceptre.projek.webapp.HttpUtils;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends javax.servlet.http.HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Boolean redirectedToLogin = (Boolean) request.getSession().getAttribute("redirectedToLogin");
        if (redirectedToLogin == null) redirectedToLogin = false;
        if (request.getSession().getAttribute("access_token") != null && !redirectedToLogin) {
            response.sendRedirect("profile");
        } else {
            request.getSession().removeAttribute("redirectedToLogin");
            RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/login.jsp");
            rs.forward(request, response);
        }
    }

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        Map<String, String> body = new LinkedHashMap<>();
        body.put("username", request.getParameter("username"));
        body.put("password", request.getParameter("password"));

        String responseString;
        try {
            responseString = HttpUtils.requestPost(HttpUtils.getIdentityServiceUrl("/login"), body);

            JSONObject responseJson = new JSONObject(responseString);
            String refresh_token = responseJson.getString("refresh_token");
            String access_token = responseJson.getString("access_token");
            Timestamp expiry_time = Timestamp.valueOf(responseJson.getString("expiry_time"));

            HttpSession session = request.getSession();
            session.setAttribute("access_token", access_token);
            session.setAttribute("refresh_token", refresh_token);
            session.setAttribute("expiry_time", expiry_time);
            session.setAttribute("username", request.getParameter("username"));
            response.sendRedirect("profile");

        } catch (IOException e) {
            request.setAttribute("error", e.getMessage());
            RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/login.jsp");
            rs.forward(request, response);
        } catch (HttpUtils.HttpUtilsException e) {
            if (e.status == 401) {
                request.setAttribute("error", "Wrong username or password.");
            } else {
                request.setAttribute("error", e.getMessage());
            }
            RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/login.jsp");
            rs.forward(request, response);
        }
    }

}
