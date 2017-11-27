package com.sceptre.projek.webservice;

import org.json.JSONObject;

import javax.jws.WebService;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

@WebService(endpointInterface = "com.sceptre.projek.webservice.LocationWS")
public class LocationWSImpl implements LocationWS {

    @Override
    public String addPreferredLocation(String access_token, String identifier, String loc_name) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            String username = validator.getUsername();
            try {
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String query = "INSERT INTO user_preferred_locations VALUES " +
                        "((SELECT id FROM `users` WHERE username = '" + username + "' LIMIT 1), " +
                        "'" + loc_name + "')";

                statement.execute(query);

                statement.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (statement != null)
                        statement.close();
                } catch (SQLException ignored) {
                    //
                }
                try {
                    if (conn != null)
                        conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            JSONResponse.put("message", "Success");
        } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
            JSONResponse.put("message", "token_expired");
        } else {
            JSONResponse.put("message", "invalid_token");
        }
        return JSONResponse.toString();
    }

    @Override
    public String editPreferredLocation(String access_token, String identifier, String loc_name, String new_loc_name) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            String username = validator.getUsername();
            try {
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String query = "UPDATE user_preferred_locations SET loc_name = '" + new_loc_name +
                        "' WHERE loc_name = '" + loc_name + "' AND user_id = (SELECT id FROM `users` WHERE username = '" +
                        username + "' LIMIT 1)";

                statement.execute(query);

                statement.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (statement != null)
                        statement.close();
                } catch (SQLException ignored) {
                    //
                }
                try {
                    if (conn != null)
                        conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            JSONResponse.put("message", "Success");
        } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
            JSONResponse.put("message", "token_expired");
        } else {
            JSONResponse.put("message", "invalid_token");
        }
        return JSONResponse.toString();
    }


    @Override
    public String deletePreferredLocation(String access_token, String identifier, String loc_name) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            String username = validator.getUsername();
            try {
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String query = "DELETE FROM user_preferred_locations WHERE loc_name = '" + loc_name +
                        "' AND user_id = (SELECT id FROM `users` WHERE username = '" + username + "' LIMIT 1)";

                statement.execute(query);

                statement.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (statement != null)
                        statement.close();
                } catch (SQLException ignored) {
                    //
                }
                try {
                    if (conn != null)
                        conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            JSONResponse.put("message", "Success");
        } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
            JSONResponse.put("message", "token_expired");
        } else {
            JSONResponse.put("message", "invalid_token");
        }
        return JSONResponse.toString();
    }
}
