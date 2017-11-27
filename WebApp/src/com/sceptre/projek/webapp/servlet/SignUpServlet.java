package com.sceptre.projek.webapp.servlet;

import com.sceptre.projek.webapp.HttpUtils;
import com.sceptre.projek.webapp.webservices.UserWS;
import com.sceptre.projek.webapp.webservices.WSClient;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet(name = "SignUpServlet", urlPatterns = {"/signup"})
public class SignUpServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            if (Boolean.parseBoolean(request.getSession().getAttribute("is_driver").toString())) {
                response.sendRedirect("chat_driver");
            } else {
               response.sendRedirect("order");
            }
            // response.sendRedirect("profile");
        } else {
            RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/signup.jsp");
            rs.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phone_number");
        boolean isDriver = request.getParameter("is_driver") != null;

        Map<String, String> body = new LinkedHashMap<>();
        body.put("username", username);
        body.put("email", email);
        body.put("password", password);

        String responseString;
        try {
            responseString = HttpUtils.requestPost(HttpUtils.getIdentityServiceUrl("/signup"), body);

            JSONObject jsonObject = new JSONObject(responseString);
            String access_token = jsonObject.getString("access_token");
            Timestamp expiry_time = Timestamp.valueOf(jsonObject.getString("expiry_time"));

            signUp(access_token, TokenValidator.getIdentifier(request), name, username, email, phoneNumber, isDriver);

            HttpSession session = request.getSession();
            session.setAttribute("access_token", access_token);
            session.setAttribute("refresh_token", access_token);
            session.setAttribute("expiry_time", expiry_time);
            session.setAttribute("username", username);
            session.setAttribute("is_driver", isDriver);

            if (isDriver) {
                response.sendRedirect("chat_driver");
            } else {
                response.sendRedirect("order");
            }

        } catch (IOException e) {
            request.setAttribute("error", e.getMessage());
            RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/signup.jsp");
            rs.forward(request, response);
        } catch (HttpUtils.HttpUtilsException e) {
            if (e.status == 401) {
                request.setAttribute("error", "Username or email is already taken.");
            } else {
                request.setAttribute("error", e.getMessage());
            }
            RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/signup.jsp");
            rs.forward(request, response);
        }
    }

    /**
     * Registers a user.
     *
     * @param access_token Access token used for authentication.
     * @param name         Name of the user.
     * @param username     Username of the user.
     * @param email        Email of the user.
     * @param phoneNumber  Phone number of the user.
     * @param isDriver     Driver status.
     */
    private void signUp(String access_token, String identifier, String name, String username, String email, String phoneNumber, boolean isDriver) {
        UserWS userWS = WSClient.getUserWS();
        if (userWS != null) {
            userWS.store(access_token, identifier, name, username, email, phoneNumber, isDriver);
        }
    }
}
