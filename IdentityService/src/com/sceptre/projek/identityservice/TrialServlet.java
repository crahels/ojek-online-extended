package com.sceptre.projek.identityservice;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "TrialServlet", urlPatterns = {"/trial"})
public class TrialServlet extends HttpServlet {

    /**
     * Login.
     *
     * @param request  Request.
     * @param response Response.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            JSONObject json = new JSONObject();
            json.put("haihai","hehe");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
