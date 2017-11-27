package com.sceptre.projek.webservice;

import org.json.JSONObject;

import javax.jws.WebService;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

@WebService(endpointInterface = "com.sceptre.projek.webservice.UserWS")
public class UserWSImpl implements UserWS {
    /**
     * Store the given user in DB.
     *
     * @param access_token Access token for authentication.
     * @param name         Name of the user.
     * @param username     Username of the user.
     * @param email        Email of the user.
     * @param phoneNumber  Phone number of the user.
     * @param isDriver     Driver status.
     * @return JSONResponse.
     */
    @Override
    public String store(String access_token, String identifier, String name, String username, String email, String phoneNumber, boolean isDriver) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try {
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                int driver = isDriver ? 1 : 0;
                String query = "INSERT INTO users(name, username, email, phone_number, is_driver) " +
                        "VALUES('" + name + "','" + username + "','" + email + "','" + phoneNumber + "','" + driver + "')";

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
                }
                try {
                    if (conn != null)
                        conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            JSONResponse.put("message", "Sign Up success.");
        } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
            JSONResponse.put("message", "token_expired");
        } else {
            JSONResponse.put("message", "invalid_token");
        }
        return JSONResponse.toString();
    }

    /**
     * Gets the user details (profile and preferred locations if driver) based on the given access token.
     *
     * @param access_token Access token for authentication.
     * @return User details in JSON format.
     */
    public String getUserDetails(String access_token, String identifier) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            String username = validator.getUsername();
            try {
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String query = "SELECT * FROM users WHERE username = '" + username + "'";

                ResultSet rs = statement.executeQuery(query);
                rs.next();
                JSONResponse.put("id", rs.getInt("id"));
                JSONResponse.put("name", rs.getString("name"));
                JSONResponse.put("username", rs.getString("username"));
                JSONResponse.put("email", rs.getString("email"));
                JSONResponse.put("phone_number", rs.getString("phone_number"));
                JSONResponse.put("is_driver", rs.getBoolean("is_driver"));
                JSONResponse.put("profile_picture", rs.getString("profile_picture"));

                if (JSONResponse.getBoolean("is_driver")) {
                    query = "SELECT COUNT(rating) AS votes, AVG(rating) AS ratings " +
                            "FROM orders " +
                            "WHERE driver_id=" + JSONResponse.getInt("id");
                    rs = statement.executeQuery(query);
                    rs.next();
                    JSONResponse.put("votes", rs.getInt("votes"));
                    JSONResponse.put("ratings", rs.getDouble("ratings"));

                    query = "SELECT * FROM user_preferred_locations WHERE user_id=" + JSONResponse.getInt("id");
                    ArrayList<String> preferredLocations = new ArrayList<>();
                    rs = statement.executeQuery(query);
                    while (rs.next()) {
                        preferredLocations.add(rs.getString("loc_name"));
                    }
                    JSONResponse.put("preferred_locations", preferredLocations);
                }
                statement.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (statement != null)
                        statement.close();
                } catch (SQLException ignored) {
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

    // Update user in DB
    public String update(String access_token, String identifier, String name, String phoneNumber, boolean isDriver, String profilePicture) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try {
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String updateProfilePictureQuery = !profilePicture.isEmpty() ? ", profile_picture='" + profilePicture + "'" : "";

                int driver = isDriver ? 1 : 0;
                String query = "UPDATE users " +
                        "SET name='" + name + "',phone_number='" + phoneNumber + "',is_driver='" + driver +
                        "'" + updateProfilePictureQuery +
                        " WHERE username='" + validator.getUsername() + "'";

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
                }
                try {
                    if (conn != null)
                        conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
            JSONResponse.put("message", "Update user success.");
        } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
            JSONResponse.put("message", "token_expired");
        } else {
            JSONResponse.put("message", "invalid_token");
        }
        return JSONResponse.toString();
    }
}
