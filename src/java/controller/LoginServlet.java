package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import dal.UserDAO;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang login
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMsg", "Email và mật khẩu không được để trống!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.checkLogin(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard/dashboard.jsp");
            } else if ("customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard/dashboard.jsp");
            } else {
                request.setAttribute("errorMsg", "Vai trò không hợp lệ!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMsg", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
