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

@WebServlet(name = "CompleteOrderServlet", urlPatterns = {"/complete_order"})
public class CompleteOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            OrderWS orderWS = WSClient.getOrderWS();
            if (orderWS != null) {
                String access_token = (String) request.getSession().getAttribute("access_token");
                int driverId = Integer.parseInt(request.getParameter("driver_id"));
                String pickingPoint = request.getParameter("picking_point");
                String destination = request.getParameter("destination");
                int rating = Integer.parseInt(request.getParameter("star"));
                String comment = request.getParameter("comment");
                String JSONResponse = orderWS.completeOrder(access_token, TokenValidator.getIdentifier(request), driverId, pickingPoint, destination, rating, comment);

                int authResult = WSClient.checkAuth(request.getSession(), response, new JSONObject(JSONResponse));
                if (authResult == WSClient.AUTH_RETRY) {
                    doPost(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    response.sendRedirect("my_previous_order");
                }
            }
        } else {
            response.sendRedirect("login");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            OrderWS orderWS = WSClient.getOrderWS();
            if (orderWS != null) {
                String access_token = (String) request.getSession().getAttribute("access_token");
                int driverId = Integer.parseInt(request.getParameter("driver_id"));
                String JSONResponse = orderWS.getDriver(access_token, TokenValidator.getIdentifier(request), driverId);
                JSONObject jsonObject = new JSONObject(JSONResponse);
                int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject);
                if (authResult == WSClient.AUTH_RETRY) {
                    doGet(request, response);
                } else if (authResult == WSClient.AUTH_OK) {
                    User driver = new User(jsonObject.getJSONObject("driver"));
                    request.setAttribute("driver", driver);
                    RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/complete_order.jsp");
                    rs.forward(request, response);
                }
            }
        } else {
            response.sendRedirect("login");
        }
    }
}
