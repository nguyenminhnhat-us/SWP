package controller.dashboard;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Category;
import model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/dashboard/manage-categories")
public class ManageCategoryController extends HttpServlet {
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "view":
                    viewCategory(request, response);
                    break;
                case "edit":
                    showEditCategory(request, response);
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/admin/manage-category.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra quyền admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "add":
                    addCategory(request, response);
                    break;
                case "update":
                    updateCategory(request, response);
                    break;
                case "delete":
                    deleteCategory(request, response);
                    break;
                default:
                    listCategories(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/admin/manage-category.jsp").forward(request, response);
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        // Lấy tham số filter và phân trang
        String searchKeyword = request.getParameter("search");
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
        
        // Thiết lập giá trị mặc định
        int page = 1;
        int pageSize = 10;
        
        try {
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
            if (pageSizeStr != null && !pageSizeStr.isEmpty()) {
                pageSize = Integer.parseInt(pageSizeStr);
                if (pageSize < 5) pageSize = 5;
                if (pageSize > 50) pageSize = 50;
            }
        } catch (NumberFormatException e) {
            // Sử dụng giá trị mặc định nếu có lỗi
        }
        
        // Lấy dữ liệu với filter và phân trang
        List<Category> categories = categoryDAO.getCategoriesWithFilter(searchKeyword, page, pageSize);
        int totalCategories = categoryDAO.getTotalFilteredCategoryCount(searchKeyword);
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);
        
        // Thiết lập attributes
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCategories", totalCategories);
        request.setAttribute("searchKeyword", searchKeyword);
        
        // Tính toán phân trang
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        
        request.getRequestDispatcher("/dashboard/admin/manage-category.jsp").forward(request, response);
    }
    
    private void viewCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        Category category = categoryDAO.getCategoryById(categoryId);
        
        if (category != null) {
            request.setAttribute("viewCategory", category);
            request.setAttribute("action", "view");
        } else {
            request.setAttribute("error", "Không tìm thấy danh mục");
        }
        
        request.getRequestDispatcher("/dashboard/admin/manage-category.jsp").forward(request, response);
    }
    
    private void showEditCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        Category category = categoryDAO.getCategoryById(categoryId);
        
        if (category != null) {
            request.setAttribute("editCategory", category);
            request.setAttribute("action", "edit");
        } else {
            request.setAttribute("error", "Không tìm thấy danh mục");
        }
        
        request.getRequestDispatcher("/dashboard/admin/manage-category.jsp").forward(request, response);
    }
    
    private void addCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        String name = request.getParameter("name").trim();
        String description = request.getParameter("description").trim();
        
        // Validation
        if (name.isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống");
            listCategories(request, response);
            return;
        }
        
        if (categoryDAO.isCategoryNameExists(name)) {
            request.setAttribute("error", "Tên danh mục đã tồn tại");
            listCategories(request, response);
            return;
        }
        
        Category category = new Category(0, name, description);
        
        if (categoryDAO.addCategory(category)) {
            request.setAttribute("success", "Thêm danh mục thành công");
        } else {
            request.setAttribute("error", "Thêm danh mục thất bại");
        }
        
        listCategories(request, response);
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("name").trim();
        String description = request.getParameter("description").trim();
        
        // Validation
        if (name.isEmpty()) {
            request.setAttribute("error", "Tên danh mục không được để trống");
            showEditCategory(request, response);
            return;
        }
        
        if (categoryDAO.isCategoryNameExistsExcludeId(name, categoryId)) {
            request.setAttribute("error", "Tên danh mục đã tồn tại");
            showEditCategory(request, response);
            return;
        }
        
        Category category = new Category(categoryId, name, description);
        
        if (categoryDAO.updateCategory(category)) {
            request.setAttribute("success", "Cập nhật danh mục thành công");
            response.sendRedirect(request.getContextPath() + "/dashboard/manage-categories");
        } else {
            request.setAttribute("error", "Cập nhật danh mục thất bại");
            showEditCategory(request, response);
        }
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        // Kiểm tra xem danh mục có cây cảnh không
        if (categoryDAO.hasPlantsInCategory(categoryId)) {
            request.setAttribute("error", "Không thể xóa danh mục vì còn có cây cảnh thuộc danh mục này");
            listCategories(request, response);
            return;
        }
        
        if (categoryDAO.deleteCategory(categoryId)) {
            request.setAttribute("success", "Xóa danh mục thành công");
        } else {
            request.setAttribute("error", "Xóa danh mục thất bại");
        }
        
        listCategories(request, response);
    }
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && "admin".equals(user.getRole());
        }
        return false;
    }
}
