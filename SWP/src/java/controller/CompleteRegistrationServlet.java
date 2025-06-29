package controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import model.User;
import dal.UserDAO;

@WebServlet(name = "CompleteRegistrationServlet", urlPatterns = {"/completeRegistration"})
public class CompleteRegistrationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");  // email đã lưu khi gửi OTP
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/registerGoogle.jsp");
            return;
        }

        // Lấy dữ liệu người dùng nhập thêm
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");  // Người dùng tự đặt mật khẩu

        if (fullName == null || fullName.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("message", "Vui lòng nhập đầy đủ thông tin.");
            request.getRequestDispatcher("/completeRegistration.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setEmail(email);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        user.setPassword(password); // nhớ hash password trong thực tế nhé
        user.setRole("customer");
        user.setIsActive(true);
        user.setAuthType("google");  // lưu user kiểu Google

        UserDAO userDAO = new UserDAO();
        userDAO.insertUsergoogle(user);

        // Xóa session email, otp sau khi đăng ký thành công
        session.removeAttribute("email");
        session.removeAttribute("otp");

        // Chuyển sang trang đăng nhập
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
