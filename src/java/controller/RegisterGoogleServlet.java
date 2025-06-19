package controller;

import utils.EmailUtility;
import utils.OTPDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import javax.mail.MessagingException;
import java.io.IOException;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "RegisterGoogleServlet", urlPatterns = {"/registerGoogle"})
public class RegisterGoogleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.getSession().setAttribute("message", "Vui lòng nhập email.");
            response.sendRedirect(request.getContextPath() + "/registerGoogle.jsp");
            return;
        }

        String otp = generateOTP();

        try {
            EmailUtility.sendOTP(email, otp);

            OTPDao otpDao = new OTPDao();
            otpDao.saveOTP(email, otp);

            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("email", email);
            session.removeAttribute("message");

            response.sendRedirect(request.getContextPath() + "/verifyOTP.jsp");

        } catch (MessagingException | SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Gửi OTP thất bại, vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/registerGoogle.jsp");
        }
    }

    private String generateOTP() {
        SecureRandom random = new SecureRandom();
        StringBuilder otp = new StringBuilder(6);
        for (int i = 0; i < 6; i++) {
            otp.append(random.nextInt(10));
        }
        return otp.toString();
    }
}
