
package com.sceptre.projek.webapp.servlet;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ChatServlet", urlPatterns = {"/chat_passenger"})
public class ChatPassengerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/chat_passenger.jsp");
        rs.forward(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher rs = request.getRequestDispatcher("/WEB-INF/view/chat_passenger.jsp");
        rs.forward(request, response);
    }
}
