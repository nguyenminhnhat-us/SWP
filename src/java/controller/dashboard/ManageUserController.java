package controller.dashboard;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.util.List;
@WebServlet(name = "ManageUserController", urlPatterns = {"/dashboard/manage-users"})

public class ManageUserController extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final int USERS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "toggle":
                toggleUserStatus(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            doGet(request, response);
            return;
        }

        switch (action) {
            case "add":
                addUser(request, response);
                break;
            case "toggle":
                toggleUserStatus(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy tham số trang hiện tại
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        // Lấy tham số tìm kiếm và filter
        String searchKeyword = request.getParameter("search");
        if (searchKeyword == null) searchKeyword = "";
        
        String roleFilter = request.getParameter("role");
        if (roleFilter == null) roleFilter = "";
        
        String statusFilter = request.getParameter("status");
        if (statusFilter == null) statusFilter = "";

        // Tính toán offset
        int offset = (currentPage - 1) * USERS_PER_PAGE;

        // Lấy danh sách người dùng và tổng số
        List<User> users = userDAO.getUsersWithPagination(offset, USERS_PER_PAGE, searchKeyword, roleFilter, statusFilter);
        int totalUsers = userDAO.getTotalUsersCount(searchKeyword, roleFilter, statusFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / USERS_PER_PAGE);

        // Set attributes
        request.setAttribute("users", users);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("usersPerPage", USERS_PER_PAGE);

        // Forward đến JSP
        request.getRequestDispatcher("/dashboard/admin/manage-user.jsp").forward(request, response);
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdParam);
                boolean success = userDAO.toggleUserStatus(userId);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Cập nhật trạng thái người dùng thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái người dùng!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            String isActiveParam = request.getParameter("isActive");
            
            // Validate required fields
            if (email == null || email.trim().isEmpty() || 
                password == null || password.trim().isEmpty() || 
                fullName == null || fullName.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            // Kiểm tra email đã tồn tại
            User existingUser = userDAO.getUserByEmail(email.trim());
            if (existingUser != null) {
                request.getSession().setAttribute("errorMessage", "Email đã tồn tại trong hệ thống!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            // Tạo user mới
            User newUser = new User();
            newUser.setEmail(email.trim());
            newUser.setPassword(password); // Trong thực tế nên hash password
            newUser.setFullName(fullName.trim());
            newUser.setPhone(phone != null ? phone.trim() : "");
            newUser.setAddress(address != null ? address.trim() : "");
            newUser.setRole(role != null ? role : "customer");
            newUser.setIsActive(isActiveParam != null && isActiveParam.equals("1"));
            newUser.setAuthType("local");
            
            // Thêm user vào database
            boolean success = userDAO.addUser(newUser);
            
            if (!success) {
                request.getSession().setAttribute("errorMessage", "Không thể thêm người dùng vào cơ sở dữ liệu!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            request.getSession().setAttribute("successMessage", "Thêm người dùng mới thành công!");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi thêm người dùng: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdParam);
                
                // Không cho phép xóa chính mình
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("user");
                if (currentUser.getUserId() == userId) {
                    request.getSession().setAttribute("errorMessage", "Không thể xóa tài khoản của chính mình!");
                    response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                    return;
                }
                
                boolean success = userDAO.deleteUser(userId);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Xóa người dùng thành công!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Không thể xóa người dùng!");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
    }
}