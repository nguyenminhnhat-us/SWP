package dal;

import controller.DBUtil;
import model.User;

import java.sql.*;

public class UserDAO {

    // Đăng nhập
    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password = ? AND is_active = 1 AND auth_type = 'local'";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật thông tin user (không cập nhật password, createdAt, authType)
    public boolean updateUser(User user) {
    String sql = "UPDATE Users SET full_name = ?, email = ?, phone = ?, address = ?, avatar_path = ? WHERE user_id = ?";
    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhone());
        ps.setString(4, user.getAddress());
        ps.setString(5, user.getAvatarPath());  // Thêm dòng này
        ps.setInt(6, user.getUserId());
        return ps.executeUpdate() > 0;
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        return false;
    }
}

    // Cập nhật mật khẩu
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmailAndAuthType(String email, String authType) {
        String sql = "SELECT * FROM Users WHERE email = ? AND auth_type = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, authType);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertUser(User user) {
        String sql = "INSERT INTO Users (email, password, full_name, phone, address, role, is_active, auth_type) VALUES (?, ?, ?, ?, ?, ?, 1, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getAuthType()); // Sử dụng auth_type từ User
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User(
                rs.getInt("user_id"),
                rs.getString("email"),
                rs.getString("password"),
                rs.getString("full_name"),
                rs.getString("phone"),
                rs.getString("address"),
                rs.getString("role"),
                rs.getBoolean("is_active"),
                rs.getString("auth_type")
        );
        user.setAvatarPath(rs.getString("avatar_path"));
        return user;
    }

    public void updatePasswordreset(String email, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE email = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertUsergoogle(User user) {
        String sql = "INSERT INTO Users (email, password, full_name, phone, address, role, is_active, auth_type) VALUES (?, ?, ?, ?, ?, ?, 1, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getAuthType());  // local hoặc google
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    public String getUserNameById(int userId) {
        String sql = "SELECT full_name FROM Users WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateAvatar(int userId, String avatarPath) {
        // Đảm bảo đường dẫn luôn bắt đầu bằng "/"
        if (avatarPath != null && !avatarPath.startsWith("/")) {
            avatarPath = "/" + avatarPath;
        }
        String sql = "UPDATE Users SET avatar_path = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarPath);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách người dùng với phân trang
    public java.util.List<User> getUsersWithPagination(int offset, int limit, String searchKeyword) {
        return getUsersWithPagination(offset, limit, searchKeyword, "", "");
    }
    
    // Lấy danh sách người dùng với phân trang và filter
    public java.util.List<User> getUsersWithPagination(int offset, int limit, String searchKeyword, String roleFilter, String statusFilter) {
        java.util.List<User> users = new java.util.ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE (full_name LIKE ? OR email LIKE ?)");
        
        // Thêm filter theo role
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND role = ?");
        }
        
        // Thêm filter theo status
        if (statusFilter != null && !statusFilter.isEmpty()) {
            if (statusFilter.equals("active")) {
                sql.append(" AND is_active = 1");
            } else if (statusFilter.equals("inactive")) {
                sql.append(" AND is_active = 0");
            }
        }
        
        sql.append(" ORDER BY user_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            String searchPattern = "%" + searchKeyword + "%";
            int paramIndex = 1;
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
            
            // Set role filter parameter
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(paramIndex++, roleFilter);
            }
            
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, limit);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Đếm tổng số người dùng
    public int getTotalUsersCount(String searchKeyword) {
        return getTotalUsersCount(searchKeyword, "", "");
    }
    
    // Đếm tổng số người dùng với filter
    public int getTotalUsersCount(String searchKeyword, String roleFilter, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Users WHERE (full_name LIKE ? OR email LIKE ?)");
        
        // Thêm filter theo role
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND role = ?");
        }
        
        // Thêm filter theo status
        if (statusFilter != null && !statusFilter.isEmpty()) {
            if (statusFilter.equals("active")) {
                sql.append(" AND is_active = 1");
            } else if (statusFilter.equals("inactive")) {
                sql.append(" AND is_active = 0");
            }
        }
        
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            String searchPattern = "%" + searchKeyword + "%";
            int paramIndex = 1;
            ps.setString(paramIndex++, searchPattern);
            ps.setString(paramIndex++, searchPattern);
            
            // Set role filter parameter
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(paramIndex++, roleFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Chuyển đổi trạng thái người dùng (active/inactive)
    public boolean toggleUserStatus(int userId) {
        String sql = "UPDATE Users SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa người dùng
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy thông tin người dùng theo ID
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm người dùng mới (wrapper cho insertUser)
    public boolean addUser(User user) {
        String sql = "INSERT INTO Users (email, password, full_name, phone, address, role, is_active, auth_type) VALUES (?, ?, ?, ?, ?, ?, ?, 'local')";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setBoolean(7, user.isActive());
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Kiểm tra email đã tồn tại (loại trừ user hiện tại)
    public boolean isEmailExistsExcludeId(String email, int userId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ? AND user_id != ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Kiểm tra email đã tồn tại
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }
}
