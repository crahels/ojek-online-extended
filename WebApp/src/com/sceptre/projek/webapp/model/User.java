package com.sceptre.projek.webapp.model;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * PR-OJEK user model.
 */
public class User {
    private int id;
    private String name;
    private String username;
    private String email;
    private String phoneNumber;
    private boolean isDriver;
    private String profilePicture;
    private int votes;
    private double ratings;
    private List<String> preferredLocations;

    /**
     * Creates a user from its JSON representation.
     * @param user JSON representation of user.
     */
    public User(JSONObject user) {
        preferredLocations = new ArrayList<>();
        try {
            id = user.getInt("id");
        } catch (JSONException e) {
            id = 0;
        }
        try {
            username = user.getString("username");
        } catch (JSONException e) {
            username = "";
        }
        try {
            name = user.getString("name");
        } catch (JSONException e) {
            name = "";
        }
        try {
            email = user.getString("email");
        } catch (JSONException e) {
            email = "";
        }
        try {
            phoneNumber = user.getString("phone_number");
        } catch (JSONException e) {
            phoneNumber = "";
        }
        try {
            isDriver = user.getBoolean("is_driver");
        } catch (JSONException e) {
            isDriver = true;
        }
        try {
            profilePicture = user.getString("profile_picture");
        } catch (JSONException e) {
            profilePicture = "../../assets/images/profile/default.png";
        }
        if (isDriver) {
            try {
                votes = user.getInt("votes");
            } catch (JSONException e) {
                votes = 0;
            }
            try {
                ratings = user.getDouble("ratings");
            } catch (JSONException e) {
                ratings = 0;
            }
            try {
                JSONArray preferredLocationsJSON = user.getJSONArray("preferred_locations");
                for (int i = 0; i < preferredLocationsJSON.length(); i++) {
                    preferredLocations.add(preferredLocationsJSON.getString(i));
                }
            } catch (JSONException e) {
            }
        }
    }

    /**
     * Parses the given JSONArray and returns a list of drivers.
     * @param driversJSON List of drivers in JSON representation.
     * @return List of drivers.
     */
    public static List<User> extractDrivers (JSONArray driversJSON) {
        List<User> drivers = new ArrayList<>();
        for (int i = 0; i < driversJSON.length(); i++) {
            drivers.add(new User(driversJSON.getJSONObject(i)));
        }
        return drivers;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public boolean isDriver() {
        return isDriver;
    }

    public String getProfilePicture() {
        return profilePicture;
    }

    public int getVotes() {
        return votes;
    }

    public double getRatings() {
        return ratings;
    }

    public List<String> getPreferredLocations() {
        return preferredLocations;
    }
}
