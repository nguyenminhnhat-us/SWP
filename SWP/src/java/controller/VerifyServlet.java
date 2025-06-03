package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "VerifyServlet", urlPatterns = {"/verifyOTP"})
public class VerifyServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response)
            throws ServletException, IOException {

        String inputOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");

        if (inputOtp != null && inputOtp.equals(sessionOtp)) {
            session.removeAttribute("otp");
            session.removeAttribute("message");
            // Chuyển đến trang nhập thông tin cá nhân
            response.sendRedirect(request.getContextPath() + "/completeRegistration.jsp");
        } else {
            session.setAttribute("message", "Mã OTP không đúng. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/verifyOTP.jsp");
        }
    }
}
