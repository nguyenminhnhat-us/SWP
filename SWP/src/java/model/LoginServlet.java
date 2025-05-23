package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

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
<<<<<<< HEAD
                response.sendRedirect("admin.jsp");
            } else if ("customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("user.jsp");  // chuyển thành index.jsp nếu dùng JSP
=======
                response.sendRedirect("admin/dashboard.jsp");
            } else if ("customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("index.jsp");  // chuyển thành index.jsp nếu dùng JSP
>>>>>>> 184b2c6dc0113fb927607ee2d6bf9a0fc3fbdf93
            } else {
                request.setAttribute("errorMsg", "Vai trò không hợp lệ!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMsg", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 184b2c6dc0113fb927607ee2d6bf9a0fc3fbdf93
