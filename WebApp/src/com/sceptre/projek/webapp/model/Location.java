package com.sceptre.projek.webapp.model;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * PR-OJEK location model.
 */
public class Location {
    private int user_id;
    private String loc_name;

    /**
     * Creates a location from its JSON representation.
     *
     * @param location JSON representation of a location.
     */
    public Location(JSONObject location) {
        try {
            user_id = location.getInt("user_id");
        } catch (JSONException e) {
            user_id = 0;
        }

        try {
            loc_name = location.getString("loc_name");
        } catch (JSONException e) {
            loc_name = "";
        }
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getLoc_name() {
        return loc_name;
    }

    public void setLoc_name(String loc_name) {
        this.loc_name = loc_name;
    }
}
