package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị login.jsp cho yêu cầu GET
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setBufferSize(8192); // Tăng kích thước bộ đệm
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
            session.setAttribute("user", user); // Lưu user với key "user"

            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin.jsp");
            } else if ("customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("errorMsg", "Vai trò không hợp lệ!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            return; // Thoát sau khi xử lý
        } else {
            request.setAttribute("errorMsg", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}



