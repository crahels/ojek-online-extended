package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "ValidateTokenServlet", urlPatterns = {"/validate"})
public class ValidateTokenServlet extends HttpServlet {
    /**
     * Generates a new access token for the given refresh token.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        try {
            JSONObject result = new JSONObject();
            Statement statement = null;
            boolean valid = false;
            boolean expired = false;
            String username = null;
            try {
                Connection conn = DatabaseManager.getConnection();
                statement = conn.createStatement();

                String query = "SELECT * FROM session WHERE access_token='" + token + "' LIMIT 1";
                ResultSet rs = statement.executeQuery(query);
                if (rs.isBeforeFirst()) {
                    valid = true;
                    rs.next();
                    username = rs.getString("username");
                    Timestamp currentTime = new Timestamp(System.currentTimeMillis());
                    if (currentTime.compareTo(rs.getTimestamp("expiry_time")) > 0) {
                        expired = true;
                    }
                }
                statement.close();

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (statement != null) statement.close();
                } catch (SQLException ignored) {
                    //
                }
            }
            //JSONObject result = new JSONObject();
            if (valid) {
                if (expired) {
                    result.put("message", "token_expired");
                } else {
                    result.put("message", "valid_token");
                    result.put("username", username);
                }
            } else {
                result.put("message", "invalid_token " + token);
            }
            Utils.sendJsonResponse(response, result);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
