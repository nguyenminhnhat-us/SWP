package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import javax.mail.MessagingException;
import model.User;
import dal.UserDAO;
import utils.EmailUtility;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        UserDAO dao = new UserDAO();
        User user = dao.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("errorMsg", "Email không tồn tại.");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        // Tạo OTP
        String otp = String.valueOf((int) (Math.random() * 900000 + 100000));
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("otpEmail", email);

        // Gửi OTP qua email (viết logic riêng nếu chưa có)
        try {
            EmailUtility.sendOTP(email, otp);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "Không thể gửi email. Vui lòng thử lại.");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("verifyForgotOTP.jsp");
    }
}
