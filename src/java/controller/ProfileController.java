package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import dal.UserDAO;
import model.User;

@WebServlet(name = "ProfileController", urlPatterns = {"/dashboard/profile"})
public class ProfileController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Lấy thông tin user mới nhất từ database
        User currentUser = userDAO.getUserByEmail(user.getEmail());
        request.setAttribute("user", currentUser);
        request.getRequestDispatcher("/dashboard/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");
        
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("update_profile".equals(action)) {
            // Cập nhật thông tin cơ bản
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            User user = new User();
            user.setUserId(sessionUser.getUserId());
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);
            user.setRole(sessionUser.getRole());
            user.setAuthType(sessionUser.getAuthType());

            if (userDAO.updateUser(user)) {
                // Cập nhật session với thông tin mới
                session.setAttribute("user", userDAO.getUserByEmail(email));
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("errorMessage", "Cập nhật thông tin thất bại!");
            }
        } else if ("change_password".equals(action)) {
            // Đổi mật khẩu
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Kiểm tra mật khẩu hiện tại
            User checkUser = userDAO.checkLogin(sessionUser.getEmail(), currentPassword);
            
            if (checkUser == null) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng!");
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Mật khẩu mới không khớp!");
            } else if (userDAO.updatePassword(sessionUser.getUserId(), newPassword)) {
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMessage", "Đổi mật khẩu thất bại!");
            }
        }

        // Lấy thông tin user mới nhất và hiển thị lại trang
        User currentUser = userDAO.getUserByEmail(sessionUser.getEmail());
        request.setAttribute("user", currentUser);
        request.getRequestDispatcher("/dashboard/profile.jsp").forward(request, response);
    }
}
