package model;

import controller.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public User checkLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password = ? AND is_active = 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getString("role"),
                    rs.getBoolean("is_active")
                );
                user.setAvatarPath(rs.getString("avatar_path")); // Lấy từ DB
                return user;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET full_name = ?, email = ?, phone = ?, address = ?, avatar_path = ? WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getAvatarPath());
            ps.setInt(6, user.getUserId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}
