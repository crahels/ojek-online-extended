package com.sceptre.projek.webapp.model;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * PR-OJEK order model.
 */
public class Order {
    private int id;
    private String customerName;
    private String driverName;
    private String customerProfilePicture;
    private String driverProfilePicture;
    private String date;
    private String pickingPoint;
    private String destination;
    private int rating;
    private String comment;

    public Order(JSONObject order) {
        id = order.getInt("id");
        try {
            customerName = order.getString("customer_name");
        } catch (JSONException e) {
            customerName = "";
        }
        try {
            driverName = order.getString("driver_name");
        } catch (JSONException e) {
            driverName = "";
        }
        try {
            customerProfilePicture = order.getString("customer_profile_picture");
        } catch (JSONException e) {
            customerProfilePicture = "../../assets/images/profile/default.png";
        }
        try {
            driverProfilePicture = order.getString("driver_profile_picture");
        } catch (JSONException e) {
            driverProfilePicture = "../../assets/images/profile/default.png";
        }
        String dateStr = order.getString("date");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            Date temp = sdf.parse(dateStr);
            Calendar.getInstance().setTime(temp);
            switch (Calendar.DATE % 10) {
                case 1:
                    sdf = new SimpleDateFormat("EEEE, MMMMM d'st' yyyy");
                    break;
                case 2:
                    sdf = new SimpleDateFormat("EEEE, MMMMM d'nd' yyyy");
                    break;
                case 3:
                    sdf = new SimpleDateFormat("EEEE, MMMMM d'rd' yyyy");
                    break;
                default:
                    sdf = new SimpleDateFormat("EEEE, MMMMM d'th' yyyy");
                    break;
            }
            date = sdf.format(temp);
        }
        catch(ParseException ex) {
            ex.printStackTrace();
        }
        pickingPoint = order.getString("picking_point");
        destination = order.getString("destination");
        rating = order.getInt("rating");
        comment = order.getString("comment");
    }

    public static List<Order> extractOrders (JSONArray ordersJSON) {
        List<Order> orders = new ArrayList<>();
        for (int i = 0; i < ordersJSON.length(); i++) {
            orders.add(new Order(ordersJSON.getJSONObject(i)));
        }
        return orders;
    }

    public int getId() {
        return id;
    }

    public String getDate() {
        return date;
    }

    public String getPickingPoint() {
        return pickingPoint;
    }

    public String getDestination() {
        return destination;
    }

    public int getRating() {
        return rating;
    }

    public String getComment() {
        return comment;
    }

    public String getDriverName() {
        return driverName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getCustomerProfilePicture() {
        return customerProfilePicture;
    }

    public String getDriverProfilePicture() {
        return driverProfilePicture;
    }
}
