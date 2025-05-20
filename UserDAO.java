/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author ADMIN
 */
import java.sql.*;
import model.User;

public class UserDAO {
    private final String connectionUrl = "jdbc:sqlserver://MSI\\SQLEXPRESS;databaseName=plant_care_system;user=sa;password=2005huuphuc;encrypt=false";

    public UserDAO() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); // Driver SQL Server
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public User checkLogin(String email, String password) {
    String sql = "SELECT * FROM Users WHERE email = ? AND password = ? AND is_active = 1";
    try (Connection conn = DriverManager.getConnection(connectionUrl);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new User(
                rs.getInt("user_id"),
                rs.getString("email"),
                rs.getString("password"),
                rs.getString("full_name"),
                rs.getString("phone"),
                rs.getString("address"),
                rs.getString("role"),
                rs.getBoolean("is_active")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}
}
