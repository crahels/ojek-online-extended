package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SignUpServlet", urlPatterns = {"/signup"})
public class SignUpServlet extends HttpServlet {
    /**
     * Registers a new user if email and username valid and returns JSON response.
     *
     * @param request  Request.
     * @param response Response.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String identifier = request.getParameter("identifier");

        try {
            JSONObject json;
            if (AuthManager.isEmailAndUsernameValid(email, username)) {
                AuthManager.register(email, username, password);
                json = AuthManager.startSession(username, identifier);
                Utils.sendJsonResponse(response, json);
            } else {
                json = new JSONObject();
                json.put("error", "Username or email is already used.");
                Utils.sendJsonResponse(response, json, 401);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
