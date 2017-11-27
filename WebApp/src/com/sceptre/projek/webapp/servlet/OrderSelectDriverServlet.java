package com.sceptre.projek.webapp.servlet;

import com.sceptre.projek.webapp.model.User;
import com.sceptre.projek.webapp.webservices.OrderWS;
import com.sceptre.projek.webapp.webservices.WSClient;
import org.json.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderSelectDriverServlet", urlPatterns = {"/order_select_driver"})
public class OrderSelectDriverServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            OrderWS orderWS = WSClient.getOrderWS();
            if (orderWS != null) {
                String access_token = (String) request.getSession().getAttribute("access_token");
                String pickingPoint = request.getParameter("picking_point");
                String destination = request.getParameter("destination");
                String preferredDriver = request.getParameter("preferred_driver");
                String JSONResponse = orderWS.getDrivers(access_token, TokenValidator.getIdentifier(request), pickingPoint, destination, preferredDriver);
                JSONObject jsonObject = new JSONObject(JSONResponse);
                int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject);
                if (authResult == WSClient.AUTH_RETRY) {
                    doGet(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    // List<User> preferredDrivers = User.extractDrivers(jsonObject.getJSONArray("preferred_drivers"));
                    // List<User> otherDrivers = User.extractDrivers(jsonObject.getJSONArray("other_drivers"));
                    request.setAttribute("preferred_drivers", jsonObject.getJSONArray("preferred_drivers"));
                    request.setAttribute("other_drivers", jsonObject.getJSONArray("other_drivers"));
                    RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/order_select_driver.jsp");
                    rs.forward(request, response);
                }
            }
        } else {
            response.sendRedirect("login");
        }
    }
}