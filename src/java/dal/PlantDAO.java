package dal;

import controller.DBUtil;
import model.Plant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlantDAO {

    public Plant getPlantById(int plantId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT plant_id, category_id, name, description, price, stock_quantity, image_url FROM Plants WHERE plant_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, plantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Plant(
                        rs.getInt("plant_id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image_url")
                );
            }
        }
        return null;
    }

    public List<Plant> getAllPlants() throws SQLException, ClassNotFoundException {
        List<Plant> plants = new ArrayList<>();
        String sql = "SELECT plant_id, category_id, name, description, price, stock_quantity, image_url FROM Plants";
        System.out.println("Bắt đầu truy vấn lúc " + new java.util.Date() + ": " + sql);
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            System.out.println("Kết nối thành công: " + conn);
            ps = conn.prepareStatement(sql);
            System.out.println("PreparedStatement được tạo: " + ps);
            rs = ps.executeQuery();
            System.out.println("ResultSet được tạo, bắt đầu đọc dữ liệu...");
            int rowCount = 0;
            while (rs.next()) {
                rowCount++;
                System.out.println("Đọc dòng " + rowCount + ": plant_id=" + rs.getInt("plant_id") + ", name=" + rs.getString("name"));
                plants.add(new Plant(
                        rs.getInt("plant_id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image_url")
                ));
            }
            System.out.println("Tổng số cây đọc được: " + plants.size());
        } catch (SQLException e) {
            System.out.println("Lỗi SQL khi truy vấn Plants lúc " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (conn != null) try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return plants;
    }

    public List<Plant> getPlantsByCategory(int categoryId) {
        List<Plant> plantList = new ArrayList<>();
        String sql = "SELECT * FROM Plants WHERE category_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Plant plant = new Plant(
                        rs.getInt("plant_id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image_url")
                );
                plantList.add(plant);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return plantList;
    }

    public List<Plant> getFeaturedPlants() throws SQLException, ClassNotFoundException {
        List<Plant> plants = new ArrayList<>();
        String sql = "SELECT p.*, c.name as category_name " +
                    "FROM Plants p " +
                    "LEFT JOIN Categories c ON p.category_id = c.category_id " +
                    "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Plant plant = new Plant();
                plant.setPlantId(rs.getInt("plant_id"));
                plant.setCategoryId(rs.getInt("category_id"));
                plant.setName(rs.getString("name"));
                plant.setDescription(rs.getString("description"));
                plant.setPrice(rs.getDouble("price"));
                plant.setStockQuantity(rs.getInt("stock_quantity"));
                plant.setImageUrl(rs.getString("image_url"));
                plant.setCreatedAt(rs.getTimestamp("created_at"));
                
                
                plants.add(plant);
            }
        } catch (SQLException e) {
            System.out.println("Error in getFeaturedPlants: " + e.getMessage());
            e.printStackTrace();
        }
        
        return plants;
    }

    public List<Plant> getTopSellingPlants(int limit) throws SQLException {
        List<Plant> list = new ArrayList<>();
        String sql = "SELECT p.plant_id, p.name, p.price, p.image_url, SUM(od.quantity) AS total_sold " +
                     "FROM Plants p " +
                     "JOIN OrderDetails od ON p.plant_id = od.plant_id " +
                     "GROUP BY p.plant_id, p.name, p.price, p.image_url " +
                     "ORDER BY total_sold DESC " +
                     "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Plant plant = new Plant();
                plant.setPlantId(rs.getInt("plant_id"));
                plant.setName(rs.getString("name"));
                plant.setPrice(rs.getDouble("price"));
                plant.setImageUrl(rs.getString("image_url"));
                // Thêm trường total_sold nếu muốn
                list.add(plant);
            }
        }
        return list;
    }

    public List<Plant> getPagedPlants(int page, int pageSize) throws SQLException {
        List<Plant> list = new ArrayList<>();
        String sql = "SELECT * FROM Plants ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tạo Plant từ rs
                // ...
                list.add(plant);
            }
        }
        return list;
    }

    public int getTotalPlantCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Plants";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }
}
