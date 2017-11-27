package com.sceptre.projek.webservice;

import org.json.JSONObject;

import javax.jws.WebService;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebService(endpointInterface = "com.sceptre.projek.webservice.OrderWS")
public class OrderWSImpl implements OrderWS{
    /**
     * Gets list of drivers (preferred and other) based on the given parameters.
     *
     * @param access_token Access token for authentication.
     * @param pickingPoint Picking point.
     * @param destination Destination.
     * @param driverName Preferred drivers name.
     * @return List of drivers in JSON format.
     */
    @Override
    public String getDrivers(String access_token, String identifier, String pickingPoint, String destination, String driverName) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            String username = validator.getUsername();
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();
                String query = "SELECT users.id, username, name, profile_picture, COUNT(rating) AS votes, AVG(rating) AS ratings " +
                        "FROM users INNER JOIN user_preferred_locations ON users.id = user_preferred_locations.user_id " +
                        "LEFT JOIN orders ON orders.driver_id= users.id " +
                        "WHERE username <> '" +  username + "' AND UPPER(name)=UPPER('" + driverName +"') AND is_driver=true " +
                        "AND (UPPER(loc_name)=UPPER('" + pickingPoint + "') OR UPPER(loc_name)=UPPER('" + destination + "')) " +
                        "GROUP BY users.id " +
                        "ORDER BY ratings DESC";

                JSONResponse.put("preferred_drivers", extractDrivers(statement.executeQuery(query)));

                query = "SELECT users.id, username, name, profile_picture, COUNT(rating) AS votes, AVG(rating) AS ratings " +
                        "FROM users INNER JOIN user_preferred_locations ON users.id = user_preferred_locations.user_id " +
                        "LEFT JOIN orders ON orders.driver_id= users.id " +
                        "WHERE username <> '" +  username + "' AND UPPER(name) <> UPPER('" + driverName +"') AND is_driver=true " +
                        "AND (UPPER(loc_name)=UPPER('" + pickingPoint + "') OR UPPER(loc_name)=UPPER('" + destination + "')) " +
                        "GROUP BY users.id " +
                        "ORDER BY ratings DESC";

                JSONResponse.put("other_drivers", extractDrivers(statement.executeQuery(query)));

                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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

    private List<JSONObject> extractDrivers(ResultSet rs) {
        List<JSONObject> drivers = new ArrayList<>();
        try {
            while(rs.next()) {
                JSONObject driver = new JSONObject();
                driver.put("id", rs.getInt("id"));
                driver.put("username", rs.getString("username"));
                driver.put("name", rs.getString("name"));
                driver.put("profile_picture", rs.getString("profile_picture"));
                driver.put("votes", rs.getInt("votes"));
                driver.put("ratings", rs.getDouble("ratings"));
                drivers.add(driver);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return drivers;
    }

    /**
     * Gets driver (name and username) from its given id.
     * @param access_token Access token for authentication.
     * @param driverId ID of the driver.
     * @return Driver (name and username) in JSON format.
     */
    @Override
    public String getDriver(String access_token, String identifier, int driverId) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String query = "SELECT name, username, profile_picture " +
                        "FROM users " +
                        "WHERE id=" + driverId;

                ResultSet rs = statement.executeQuery(query);
                rs.next();
                JSONObject driver = new JSONObject();
                driver.put("name", rs.getString("name"));
                driver.put("username", rs.getString("username"));
                driver.put("profile_picture", rs.getString("profile_picture"));

                JSONResponse.put("driver", driver);
                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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

    /**
     * Completes an order and saves it to database.
     * @param access_token Access token for authentication.
     * @param driverId ID of the driver.
     * @param pickingPoint Picking point.
     * @param destination Destination.
     * @param rating Rating given by the user.
     * @param comment Comment.
     * @return Message (sucess / invalid_token / token_expired) in JSON format.
     */
    @Override
    public String completeOrder(String access_token, String identifier, int driverId, String pickingPoint, String destination, int rating, String comment) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            String username = validator.getUsername();
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                String query = "SELECT id " +
                        "FROM users " +
                        "WHERE username='" + username + "'";

                ResultSet rs = statement.executeQuery(query);
                rs.next();
                int customerId = rs.getInt("id");

                query = "INSERT INTO orders(driver_id, customer_id, picking_point, destination, rating, comment) " +
                        "VALUES(" + driverId + ", " + customerId + ", '" + pickingPoint + "', '" + destination + "', " + rating + ", '" + comment + "')";

                statement.executeUpdate(query);

                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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
    public String getCustomerOrders(String access_token, String identifier) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();

                int customerId = getUserId(statement, validator.getUsername());
                String query = "SELECT orders.id, name AS driver_name, profile_picture AS driver_profile_picture, date, picking_point, destination, rating, comment " +
                        "FROM orders INNER JOIN users ON orders.driver_id = users.id " +
                        "WHERE customer_id='" + customerId + "' AND customer_hidden=false " +
                        "order by date desc";

                JSONResponse.put("customer_orders", extractCustomerOrders(statement.executeQuery(query)));

                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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
    public String getDriverOrders(String access_token, String identifier) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();
                int driverId = getUserId(statement, validator.getUsername());
                String query = "SELECT orders.id, name AS customer_name, profile_picture AS customer_profile_picture, date, picking_point, destination, rating, comment " +
                        "FROM orders INNER JOIN users ON orders.customer_id = users.id " +
                        "WHERE driver_id='" + driverId + "' AND driver_hidden=false " +
                        "order by date desc";

                JSONResponse.put("driver_orders", extractDriverOrders(statement.executeQuery(query)));

                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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

    private List<JSONObject> extractCustomerOrders(ResultSet rs) {
        List<JSONObject> orders = new ArrayList<>();
        try {
            while(rs.next()) {
                JSONObject order = new JSONObject();
                order.put("id", rs.getInt("id"));
                order.put("driver_name", rs.getString("driver_name"));
                order.put("driver_profile_picture", rs.getString("driver_profile_picture"));
                order.put("date", rs.getString("date"));
                order.put("picking_point", rs.getString("picking_point"));
                order.put("destination", rs.getString("destination"));
                order.put("rating", rs.getInt("rating"));
                order.put("comment", rs.getString("comment"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    private List<JSONObject> extractDriverOrders(ResultSet rs) {
        List<JSONObject> orders = new ArrayList<>();
        try {
            while(rs.next()) {
                JSONObject order = new JSONObject();
                order.put("id", rs.getInt("id"));
                order.put("customer_name", rs.getString("customer_name"));
                order.put("customer_profile_picture", rs.getString("customer_profile_picture"));
                order.put("date", rs.getString("date"));
                order.put("picking_point", rs.getString("picking_point"));
                order.put("destination", rs.getString("destination"));
                order.put("rating", rs.getInt("rating"));
                order.put("comment", rs.getString("comment"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    private int getUserId(Statement statement, String username) {
        String query = "SELECT id FROM users WHERE username='" + username + "'";
        try {
            ResultSet rs = statement.executeQuery(query);
            rs.next();
            return rs.getInt("id");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public String hideCustomer(String access_token, String identifier, int orderId) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();
                String query = "UPDATE orders " +
                        "SET customer_hidden=true " +
                        "WHERE id='" + orderId + "'";

                statement.executeUpdate(query);

                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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
    public String hideDriver(String access_token, String identifier, int orderId) {
        TokenValidator validator = new TokenValidator(access_token, identifier);
        JSONObject JSONResponse = new JSONObject();
        if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
            Connection conn = null;
            Statement statement = null;
            try{
                conn = DatabaseManager.createConnection();
                statement = conn.createStatement();
                String query = "UPDATE orders " +
                        "SET driver_hidden=true " +
                        "WHERE id='" + orderId + "'";

                statement.executeUpdate(query);

                statement.close();
                conn.close();
            } catch(Exception e){
                e.printStackTrace();
            }finally{
                try{
                    if(statement!=null)
                        statement.close();
                }catch(SQLException ignored){
                }
                try{
                    if(conn!=null)
                        conn.close();
                }catch(SQLException se){
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
