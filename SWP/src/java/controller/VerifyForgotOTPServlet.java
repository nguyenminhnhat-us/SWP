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

@WebServlet("/verifyForgotOTP")
public class VerifyForgotOTPServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userOTP = request.getParameter("otp");
        HttpSession session = request.getSession();
        String realOTP = (String) session.getAttribute("otp");

        if (userOTP.equals(realOTP)) {
            response.sendRedirect("resetPassword.jsp");
        } else {
            request.setAttribute("error", "Mã OTP không đúng.");
            request.getRequestDispatcher("verifyForgotOTP.jsp").forward(request, response);

        }
    }
}

