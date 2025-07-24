    package model;
    import dal.UserDAO;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.*;

    import java.io.IOException;

    @WebServlet("/register")
    public class RegisterServlet extends HttpServlet {

        private final UserDAO userDAO = new UserDAO();

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String fullName = request.getParameter("full_name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Kiểm tra email hợp lệ
            if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
                request.setAttribute("errorMsg", "Email không đúng định dạng.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu
            if (password.length() < 6) {
                request.setAttribute("errorMsg", "Mật khẩu phải có ít nhất 6 ký tự.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Kiểm tra số điện thoại
            if (!phone.matches("^(\\+84|0)[0-9]{9}$")) {
    request.setAttribute("errorMsg", "Số điện thoại không hợp lệ.");
    request.getRequestDispatcher("register.jsp").forward(request, response);
    return;
}

            // Kiểm tra email đã tồn tại
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("errorMsg", "Email đã được sử dụng.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Tạo user mới
            User newUser = new User(0, email, password, fullName, phone, address, "customer", true);
            userDAO.insertUser(newUser);
            response.sendRedirect("login.jsp?success=1");
        }
    }