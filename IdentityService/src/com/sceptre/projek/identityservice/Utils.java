package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class Utils {
    public static void sendJsonResponse(HttpServletResponse response, JSONObject json, int status) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }

    public static void sendJsonResponse(HttpServletResponse response, JSONObject json) throws IOException {
        sendJsonResponse(response, json, 200);
    }
}
