/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.checkLogin(email, password);
if (user != null) {
    HttpSession session = request.getSession();
    session.setAttribute("user", user);
    response.sendRedirect("index.jsp");
} else {
    request.setAttribute("errorMsg", "Email hoặc mật khẩu không đúng!");
    request.getRequestDispatcher("login.jsp").forward(request, response);
}

    }
}
