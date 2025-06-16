package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    public static final Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        String url = "jdbc:sqlserver://localhost:1433;databaseName=plant_care_systemcu;encrypt=true;trustServerCertificate=true";
        return DriverManager.getConnection(url, "sa", "minhnhat1234");

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
