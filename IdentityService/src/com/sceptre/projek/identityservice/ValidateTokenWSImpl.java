package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.jws.WebService;
import java.sql.*;

@WebService(endpointInterface = "com.sceptre.projek.identityservice.ValidateTokenWS")
public class ValidateTokenWSImpl implements ValidateTokenWS {
    /**
     * Validates the given access token.
     *
     * @param access_token Access token to be validated.
     * @return JSON response.
     */
    @Override
    public String validateToken(String access_token) {
        JSONObject result = new JSONObject();
        Statement statement = null;
        boolean valid = false;
        boolean expired = false;
        String username = null;
        try {
            Connection conn = DatabaseManager.getConnection();
            statement = conn.createStatement();

            String query = "SELECT * FROM session WHERE access_token='" + access_token + "' LIMIT 1";
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
            result.put("message", "invalid_token");
        }
        return result.toString();
    }
}
