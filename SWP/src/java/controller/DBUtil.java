package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    public static final Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=plant_care_system;encrypt=true;trustServerCertificate=true";
<<<<<<< HEAD
        return DriverManager.getConnection(url, "sa", "2005huuphuc");
=======
        return DriverManager.getConnection(url, "sa", "1");
>>>>>>> 184b2c6dc0113fb927607ee2d6bf9a0fc3fbdf93
    }
    
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("Kết nối tới database thành công!");
            } else {
                System.out.println("Kết nối thất bại!");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("Không tìm thấy driver SQL Server.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Lỗi khi kết nối tới database.");
            e.printStackTrace();
        }
    }
}
