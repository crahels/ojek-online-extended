package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Base64;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    /**
     * Login.
     *
     * @param request  Request.
     * @param response Response.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String identifier = request.getParameter("identifier");

        try {
            JSONObject json;
            if (AuthManager.isCredentialValid(username, password)) {
                json = AuthManager.startSession(username, identifier);
                Utils.sendJsonResponse(response, json);
            } else {
                json = new JSONObject();
                json.put("error", "Invalid credentials.");
                Utils.sendJsonResponse(response, json, 401);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
