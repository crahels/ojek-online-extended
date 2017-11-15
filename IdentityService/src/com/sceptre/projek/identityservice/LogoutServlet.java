package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    /**
     * Logout.
     *
     * @param request  Request.
     * @param response Response.
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accessToken = request.getParameter("access_token");

        Statement statement = null;
        try {
            Connection conn = DatabaseManager.getConnection();
            statement = conn.createStatement();
            String query = "DELETE FROM `session` WHERE access_token='" + accessToken + "'";
            statement.execute(query);
            statement.close();

        } catch (Exception e) {
            throw new ServletException(e);
        } finally {
            try {
                if (statement != null) statement.close();
            } catch (SQLException ignored) {
                //
            }
        }

        JSONObject json = new JSONObject();
        json.put("message", "Logged out successfully.");
        Utils.sendJsonResponse(response, json);
    }
}
