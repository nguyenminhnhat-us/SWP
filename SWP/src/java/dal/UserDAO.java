package dal;

import controller.DBUtil;
import java.math.BigDecimal;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
    public List<User> getExpertsWithProfiles() {
        List<User> experts = new ArrayList<>();
        String sql = "SELECT u.*, ep.introduction, ep.achievements, ep.specialties, ep.gallery_image_1, ep.gallery_image_2, ep.gallery_image_3 " +
                     "FROM Users u INNER JOIN ExpertProfiles ep ON u.user_id = ep.user_id " +
                     "WHERE u.role = 'expert' AND u.is_active = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                user.setBio(rs.getString("introduction"));
                user.setAchievements(rs.getString("achievements"));
                user.setSpecialties(rs.getString("specialties"));
                user.setGallery1(rs.getString("gallery_image_1"));
                user.setGallery2(rs.getString("gallery_image_2"));
                user.setGallery3(rs.getString("gallery_image_3"));
                experts.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return experts;
    }
    // Cập nhật thông tin user (không cập nhật password, createdAt, authType)
public boolean updateUser(User user) {
    String sql = "UPDATE Users SET full_name = ?, email = ?, phone = ?, address = ?, avatar_path = ?, role = ?, is_active = ? WHERE user_id = ?";
    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhone());
        ps.setString(4, user.getAddress());
        ps.setString(5, user.getAvatarPath());
        ps.setString(6, user.getRole());
        ps.setBoolean(7, user.isActive());
        ps.setInt(8, user.getUserId());
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
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setAvatarPath(rs.getString("avatar_path"));
        user.setAuthType(rs.getString("auth_type"));
        user.setBio(rs.getString("bio"));
        user.setExperienceYears(rs.getInt("experience_years"));
        user.setPricePerDay(rs.getBigDecimal("price_per_day"));
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
    public BigDecimal getExpertDailyPrice(int expertId) {
        String sql = "SELECT price_per_day FROM Users WHERE user_id = ? AND role = 'expert'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("price_per_day");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<User> getAllExperts() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'expert'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractUserFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<User> getUsersByIds(List<Integer> userIds) {
    List<User> list = new ArrayList<>();
    if (userIds == null || userIds.isEmpty()) return list;
    StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE user_id IN (");
    for (int i = 0; i < userIds.size(); i++) {
        sql.append("?");
        if (i < userIds.size() - 1) sql.append(",");
    }
    sql.append(")");
    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        for (int i = 0; i < userIds.size(); i++) {
            ps.setInt(i + 1, userIds.get(i));
        }
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(extractUserFromResultSet(rs));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}