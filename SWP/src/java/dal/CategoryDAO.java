package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import controller.DBUtil;

public class CategoryDAO {
    
    public List<Category> getAllCategories() throws SQLException, ClassNotFoundException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Categories";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("category_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                Category category = new Category(id, name, description);
                list.add(category);
            }
        }
        return list;
    }
    
    // Lấy danh sách danh mục có phân trang và filter
    public List<Category> getCategoriesWithFilter(String searchKeyword, int page, int pageSize) 
            throws SQLException, ClassNotFoundException {
        List<Category> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Categories WHERE 1=1");
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        
        sql.append(" ORDER BY category_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }
            
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("category_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                Category category = new Category(id, name, description);
                list.add(category);
            }
        }
        return list;
    }
    
    // Đếm tổng số danh mục có filter
    public int getTotalFilteredCategoryCount(String searchKeyword) 
            throws SQLException, ClassNotFoundException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Categories WHERE 1=1");
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
        }
        
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String keyword = "%" + searchKeyword.trim() + "%";
                ps.setString(1, keyword);
                ps.setString(2, keyword);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public String getCategoryNameById(int categoryId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT name FROM Categories WHERE category_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        }
        return null;
    }
    
    // Lấy danh mục theo ID
    public Category getCategoryById(int categoryId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM Categories WHERE category_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("category_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                return new Category(id, name, description);
            }
        }
        return null;
    }
    
    // Thêm danh mục mới
    public boolean addCategory(Category category) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Categories (name, description) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            return ps.executeUpdate() > 0;
        }
    }
    
    // Cập nhật danh mục
    public boolean updateCategory(Category category) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE Categories SET name = ?, description = ? WHERE category_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            return ps.executeUpdate() > 0;
        }
    }
    
    // Xóa danh mục
    public boolean deleteCategory(int categoryId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM Categories WHERE category_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Kiểm tra tên danh mục đã tồn tại
    public boolean isCategoryNameExists(String name) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Categories WHERE name = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    // Kiểm tra tên danh mục đã tồn tại (loại trừ ID hiện tại)
    public boolean isCategoryNameExistsExcludeId(String name, int categoryId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Categories WHERE name = ? AND category_id != ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    // Kiểm tra danh mục có cây cảnh không
    public boolean hasPlantsInCategory(int categoryId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Plants WHERE category_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}
