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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Statement;

@WebServlet(name = "ChatDriverServlet", urlPatterns = {"/chat_driver"})
public class ChatDriverServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            String access_token = (String) request.getSession().getAttribute("access_token");
            TokenValidator validator = new TokenValidator(access_token, TokenValidator.getIdentifier(request));
            JSONObject JSONResponse = new JSONObject();
            if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
                JSONResponse.put("message", "Success");
            } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
                JSONResponse.put("message", "token_expired");
            } else {
                JSONResponse.put("message", "invalid_token");
            }
            String JSONRes = JSONResponse.toString();
            JSONObject jsonObject = new JSONObject(JSONRes);
            int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject);
            if (authResult == WSClient.AUTH_RETRY) {
                doGet(request, response);
            } else if (authResult == WSClient.AUTH_OK) {
                RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/chat_driver.jsp");
                rs.forward(request, response);
            }
        } else {
            response.sendRedirect("login");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("access_token") != null) {
            String access_token = (String) request.getSession().getAttribute("access_token");
            TokenValidator validator = new TokenValidator(access_token, TokenValidator.getIdentifier(request));
            JSONObject JSONResponse = new JSONObject();
            if (validator.getTokenStatus() == TokenValidator.TOKEN_VALID) {
                JSONResponse.put("message", "Success");
            } else if (validator.getTokenStatus() == TokenValidator.TOKEN_EXPIRED) {
                JSONResponse.put("message", "token_expired");
            } else {
                JSONResponse.put("message", "invalid_token");
            }
            String JSONRes = JSONResponse.toString();
            JSONObject jsonObject = new JSONObject(JSONRes);
            int authResult = WSClient.checkAuth(request.getSession(), response, jsonObject);
            if (authResult == WSClient.AUTH_RETRY) {
                doGet(request, response);
            } else if (authResult == WSClient.AUTH_OK) {
                RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/chat_driver.jsp");
                rs.forward(request, response);
            }
        } else {
            response.sendRedirect("login");
        }
    }
}