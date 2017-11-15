package com.sceptre.projek.webapp.servlet;

import com.sceptre.projek.webapp.model.User;
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

@WebServlet(name = "OrderServlet", urlPatterns = {"/order"})
public class OrderServlet extends HttpServlet {
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
                    RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/order.jsp");
                    rs.forward(request, response);
                }
            }
        } else {
            response.sendRedirect("login");
        }
    }
}