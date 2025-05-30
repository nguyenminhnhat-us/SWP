package com.yourpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import model.UserDAO;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Kiểm tra mật khẩu hiện tại
        if (!user.getPassword().equals(currentPassword)) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu mới trùng khớp
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu
        boolean updateSuccess = userDAO.updatePassword(user.getUserId(), newPassword);

        if (updateSuccess) {
            // Cập nhật lại trong session
            user.setPassword(newPassword);
            session.setAttribute("user", user);

            request.setAttribute("message", "Password changed successfully!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
        }
    }
}
