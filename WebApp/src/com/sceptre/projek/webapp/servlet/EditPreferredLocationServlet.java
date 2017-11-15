package com.sceptre.projek.webapp.servlet;

import com.sceptre.projek.webapp.model.User;
import com.sceptre.projek.webapp.webservices.LocationWS;
import com.sceptre.projek.webapp.webservices.UserWS;
import com.sceptre.projek.webapp.webservices.WSClient;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "EditPreferredLocationServlet", urlPatterns = {"/edit_preferred_location"})
public class EditPreferredLocationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            UserWS userWS = WSClient.getUserWS();
            if (userWS != null) {
                String JSONResponse = userWS.getUserDetails((String) request.getSession().getAttribute("access_token"));
                JSONObject jsonObject = new JSONObject(JSONResponse);
                int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject);
                if (authResult == WSClient.AUTH_RETRY) {
                    doGet(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    User user = new User(jsonObject);
                    request.setAttribute("user", user);
                    RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/edit_preferred_location.jsp");
                    rs.forward(request, response);
                }
            }
        } else {
            response.sendRedirect("login");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            LocationWS locationWS = WSClient.getLocationWS();
            if (locationWS != null) {
                String access_token = (String) request.getSession().getAttribute("access_token");
                String loc_name = request.getParameter("loc_name");
                String JSONResponse = locationWS.addPreferredLocation(access_token, loc_name);
                JSONObject jsonObject = new JSONObject(JSONResponse);
                int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject);
                if (authResult == WSClient.AUTH_RETRY) {
                    doPost(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    response.sendRedirect("edit_preferred_location");
                }
            }
        } else {
            response.sendRedirect("login");
        }
    }

    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            LocationWS locationWS = WSClient.getLocationWS();
            if (locationWS != null) {
                String access_token = (String) request.getSession().getAttribute("access_token");
                String loc_name = request.getParameter("loc_name");
                String new_loc_name = request.getParameter("new_loc_name");
                String JSONResponse = locationWS.editPreferredLocation(access_token, loc_name, new_loc_name);
                JSONObject jsonObject = new JSONObject(JSONResponse);
                int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject, true);
                if (authResult == WSClient.AUTH_RETRY) {
                    doPut(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    response.setStatus(200);
                }
            }
        } else {
            response.sendError(401, "Please log in first.");
        }
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            LocationWS locationWS = WSClient.getLocationWS();
            if (locationWS != null) {
                String access_token = (String) request.getSession().getAttribute("access_token");
                String loc_name = request.getParameter("loc_name");
                
                String JSONResponse = locationWS.deletePreferredLocation(access_token, loc_name);
                JSONObject jsonObject = new JSONObject(JSONResponse);
                int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject, true);
                if (authResult == WSClient.AUTH_RETRY) {
                    doDelete(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    response.setStatus(200);
                }
            }
        } else {
            response.sendError(401, "Please log in first.");
        }
    }
}
