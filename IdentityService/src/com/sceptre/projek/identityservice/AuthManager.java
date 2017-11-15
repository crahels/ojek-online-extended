package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.*;
import java.util.Base64;

/**
 * Random access token generator.
 */
class AuthManager {

    /**
     * Expiry time of an access token (1 hour).
     */
    private static int EXPIRY_TIME = 60 * 60 * 1000;

    /**
     * Generates a random access token.
     *
     * @return Generated access token in Base64.
     */
    private static String generateToken() throws NoSuchAlgorithmException {
        MessageDigest messageDigest;
        SecureRandom prng = SecureRandom.getInstance("SHA1PRNG");
        String randomNum = Integer.toString(prng.nextInt());

        messageDigest = MessageDigest.getInstance("SHA-256");
        messageDigest.update(randomNum.getBytes());
        byte[] messageDigestResult = messageDigest.digest();

        return Base64.getEncoder().encodeToString(messageDigestResult);
    }

    /**
     * Generates an access token and a refresh token for the given username and saves it to the DB.
     *
     * @param username Username whose access token to be generated.
     * @return JSON containing access token and expiry time.
     */
    static JSONObject startSession(String username) throws NoSuchAlgorithmException, SQLException, ClassNotFoundException {
        String refreshToken = generateToken();
        String accessToken = generateToken();
        Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + EXPIRY_TIME);

        Statement statement = null;
        Connection conn = DatabaseManager.getConnection();

        try {
            statement = conn.createStatement();

            String query = "INSERT INTO session (username, refresh_token, access_token, expiry_time)" +
                    " VALUES ('%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE access_token = '%s', expiry_time = '%s'";
            query = String.format(query, username, refreshToken, accessToken, expiryTime.toString(),
                    accessToken, expiryTime.toString());

            statement.execute(query);
            statement.close();

        } finally {
            try {
                if (statement != null) statement.close();
            } catch (SQLException ignored) {
                //
            }
        }

        // Get newest refresh token, whether it changed or not.
        try {
            statement = conn.createStatement();
            String query = "SELECT refresh_token FROM session WHERE username='" + username + "' LIMIT 1";
            ResultSet rs = statement.executeQuery(query);
            if (rs.next()) {
                refreshToken = rs.getString("refresh_token");
            }
            statement.close();
        } finally {
            try {
                if (statement != null) statement.close();
            } catch (SQLException ignored) {
                //
            }
        }

        JSONObject result = new JSONObject();
        result.put("refresh_token", refreshToken);
        result.put("access_token", accessToken);
        result.put("expiry_time", expiryTime);
        return result;
    }

    /**
     * Regenerates an access token for the given refresh token.
     *
     * @param refreshToken Session refresh token which access token is to be regenerated.
     * @return JSON containing new access token and expiry time.
     */
    static JSONObject regenerateAccessToken(String refreshToken) throws ClassNotFoundException, SQLException, NoSuchAlgorithmException {
        String accessToken = generateToken();
        Timestamp expiryTime = new Timestamp(System.currentTimeMillis() + EXPIRY_TIME);

        Statement statement = null;
        try {
            Connection conn = DatabaseManager.getConnection();
            statement = conn.createStatement();

            String query = "UPDATE session SET access_token='%s', expiry_time='%s' WHERE refresh_token='%s'";
            query = String.format(query, accessToken, expiryTime.toString(), refreshToken);

            statement.execute(query);
            statement.close();

        } finally {
            try {
                if (statement != null) statement.close();
            } catch (SQLException ignored) {
                //
            }
        }

        JSONObject result = new JSONObject();
        result.put("access_token", accessToken);
        result.put("expiry_time", expiryTime);
        return result;
    }

    /**
     * Checks whether the given credential is valid or not.
     *
     * @param username username to be checked.
     * @param password password to be checked.
     * @return true if credentials is valid else false.
     */
    static boolean isCredentialValid(String username, String password) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        boolean valid = false;
        Statement statement = null;
        try {
            Connection conn = DatabaseManager.getConnection();
            statement = conn.createStatement();

            String query = "SELECT * FROM users WHERE username='" + username + "' LIMIT 1";
            ResultSet rs = statement.executeQuery(query);
            if (rs.isBeforeFirst()) { // There is a matching user
                rs.next();
                // Verify password (decrypt)
                MessageDigest messageDigest;
                messageDigest = MessageDigest.getInstance("SHA-256");
                messageDigest.update(password.getBytes());
                byte[] messageDigestResult = messageDigest.digest();
                valid = MessageDigest.isEqual(messageDigestResult, Base64.getDecoder().decode(rs.getString("password")));
            }

            statement.close();
        } finally {
            try {
                if (statement != null) statement.close();
            } catch (SQLException ignored) {
                //
            }
        }
        return valid;
    }

    /**
     * Checks whether the given email and username is valid or not (has been used or not).
     *
     * @param email    email to be checked.
     * @param username username to be checked.
     * @return true if the email and username is valid else false.
     */
    static boolean isEmailAndUsernameValid(String email, String username) throws SQLException, ClassNotFoundException {
        Statement statement = null;
        boolean exist;
        try {
            Connection conn = DatabaseManager.getConnection();
            statement = conn.createStatement();

            String query = "SELECT * FROM users WHERE email='" + email + "' OR username = '" + username + "' LIMIT 1";
            exist = (statement.executeQuery(query).isBeforeFirst());
            statement.close();

        } finally {
            try {
                if (statement != null) statement.close();
            } catch (SQLException ignored) {
                //
            }
        }
        return !exist;
    }

    /**
     * Registers a user for the given email, username, and password.
     *
     * @param email    email to be registered.
     * @param username username to be registered.
     * @param password password.
     */
    static void register(String email, String username, String password) throws SQLException, ClassNotFoundException, NoSuchAlgorithmException {
        Statement statement = null;
        MessageDigest messageDigest;
        try {
            Connection conn = DatabaseManager.getConnection();
            statement = conn.createStatement();

            messageDigest = MessageDigest.getInstance("SHA-256");
            messageDigest.update(password.getBytes());
            byte[] messageDigestResult = messageDigest.digest();
            password = Base64.getEncoder().encodeToString(messageDigestResult);

            String query = "INSERT INTO users (`username`, `email`, `password`) VALUES ('%s', '%s', '%s')";
            query = String.format(query, username, email, password);
            statement.execute(query);
            statement.close();

        } finally {
            try {
                if (statement != null)
                    statement.close();
            } catch (SQLException ignored) {
                //
            }
        }
    }
}
