/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dal.UserDAO;

/**
 *
 * @author ADMIN
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("otpEmail");
        String newPassword = request.getParameter("newPassword");

        if (email != null && newPassword != null) {
            UserDAO dao = new UserDAO();
            dao.updatePasswordreset(email, newPassword);

            session.removeAttribute("otp");
            session.removeAttribute("otpEmail");

            response.sendRedirect("login.jsp?resetSuccess=1");
        } else {
            response.sendRedirect("forgotPassword.jsp");
        }
    }
}