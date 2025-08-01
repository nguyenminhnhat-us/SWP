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
            case "view":
                viewUser(request, response);
                break;
            case "edit":
                showEditUser(request, response);
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
            case "update":
                updateUser(request, response);
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
    System.out.println(">>> [DEBUG] listUsers() called");

    // Đoạn này đã có rồi
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

    // DEBUG
    System.out.println(">>> [DEBUG] currentPage = " + currentPage);

    String searchKeyword = request.getParameter("search");
    if (searchKeyword == null) searchKeyword = "";

    String roleFilter = request.getParameter("role");
    if (roleFilter == null) roleFilter = "";

    String statusFilter = request.getParameter("status");
    if (statusFilter == null) statusFilter = "";

    int offset = (currentPage - 1) * USERS_PER_PAGE;

    List<User> users = userDAO.getUsersWithPagination(offset, USERS_PER_PAGE, searchKeyword, roleFilter, statusFilter);
    System.out.println(">>> [DEBUG] Fetched users: " + users.size());

    // Gán lại lên request
    request.setAttribute("users", users);
    

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
    
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            request.setAttribute("viewUser", user);
            request.setAttribute("action", "view");
            request.getRequestDispatcher("/dashboard/admin/manage-user.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
        }
    }
    
    private void showEditUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            User user = userDAO.getUserById(userId);
            
            if (user == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            request.setAttribute("editUser", user);
            request.setAttribute("action", "edit");
            request.getRequestDispatcher("/dashboard/admin/manage-user.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Lấy thông tin từ form
            String userIdParam = request.getParameter("userId");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String role = request.getParameter("role");
            String isActiveParam = request.getParameter("isActive");
            
            // Validate required fields
            if (userIdParam == null || userIdParam.isEmpty() ||
                email == null || email.trim().isEmpty() || 
                fullName == null || fullName.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            int userId = Integer.parseInt(userIdParam);
            
            // Lấy thông tin user hiện tại
            User existingUser = userDAO.getUserById(userId);
            if (existingUser == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy người dùng!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
                return;
            }
            
            // Kiểm tra email đã tồn tại (trừ user hiện tại)
            User userWithEmail = userDAO.getUserByEmail(email.trim());
            if (userWithEmail != null && userWithEmail.getUserId() != userId) {
                request.getSession().setAttribute("errorMessage", "Email đã tồn tại trong hệ thống!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users?action=edit&userId=" + userId);
                return;
            }
            
            // Cập nhật thông tin user
            existingUser.setEmail(email.trim());
            existingUser.setFullName(fullName.trim());
            existingUser.setPhone(phone != null ? phone.trim() : "");
            existingUser.setAddress(address != null ? address.trim() : "");
            existingUser.setRole(role != null ? role : "customer");
            existingUser.setIsActive(isActiveParam != null && isActiveParam.equals("1"));
            
            // Cập nhật user trong database
            boolean success = userDAO.updateUser(existingUser);
            
            if (!success) {
                request.getSession().setAttribute("errorMessage", "Không thể cập nhật thông tin người dùng!");
                response.sendRedirect(request.getContextPath() + "/dashboard/manage-users?action=edit&userId=" + userId);
                return;
            }
            
            request.getSession().setAttribute("successMessage", "Cập nhật thông tin người dùng thành công!");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID người dùng không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật người dùng: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/dashboard/manage-users");
    }
}