package dal;

import controller.DBUtil;
import model.Plant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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

    public List<Plant> getTopSellingPlants(int limit) throws SQLException, ClassNotFoundException {
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

    public List<Plant> getPagedPlants(int page, int pageSize) throws SQLException, ClassNotFoundException {
        List<Plant> list = new ArrayList<>();
        String sql = "SELECT * FROM Plants ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int plantId = rs.getInt("plant_id");
                int categoryId = rs.getInt("category_id");
                String name = rs.getString("name");
                String description = rs.getString("description");
                double price = rs.getDouble("price");
                int stockQuantity = rs.getInt("stock_quantity");
                String imageUrl = rs.getString("image_url");
                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                Plant plant = new Plant(plantId, categoryId, name, description, price, stockQuantity, imageUrl);
                plant.setCreatedAt(createdAt);
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
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(PlantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public List<Plant> getRelatedPlants(int categoryId, int plantId, int limit) throws SQLException, ClassNotFoundException {
        List<Plant> list = new ArrayList<>();
        String sql = "SELECT * FROM Plants WHERE category_id = ? AND plant_id <> ? ORDER BY NEWID() OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, plantId);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Plant p = new Plant(
                    rs.getInt("plant_id"),
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image_url")
                );
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }
        }
        return list;
    }

    public String getPlantNameById(int plantId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT name FROM Plants WHERE plant_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, plantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        }
        return null;
    }

    // CRUD Methods for Plant Management
    public boolean addPlant(Plant plant) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Plants (category_id, name, description, price, stock_quantity, image_url) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, plant.getCategoryId());
            ps.setString(2, plant.getName());
            ps.setString(3, plant.getDescription());
            ps.setDouble(4, plant.getPrice());
            ps.setInt(5, plant.getStockQuantity());
            ps.setString(6, plant.getImageUrl());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updatePlant(Plant plant) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE Plants SET category_id = ?, name = ?, description = ?, price = ?, stock_quantity = ?, image_url = ? WHERE plant_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, plant.getCategoryId());
            ps.setString(2, plant.getName());
            ps.setString(3, plant.getDescription());
            ps.setDouble(4, plant.getPrice());
            ps.setInt(5, plant.getStockQuantity());
            ps.setString(6, plant.getImageUrl());
            ps.setInt(7, plant.getPlantId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deletePlant(int plantId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM Plants WHERE plant_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, plantId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isPlantNameExists(String name) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Plants WHERE name = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean isPlantNameExistsExcludeId(String name, int plantId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Plants WHERE name = ? AND plant_id != ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, plantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    public List<Plant> searchPlantsWithFilter(String searchKeyword, Integer categoryId, String stockStatus, int page, int pageSize) 
            throws SQLException, ClassNotFoundException {
        List<Plant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Plants WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện tìm kiếm theo tên
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + searchKeyword.trim() + "%");
        }
        
        // Thêm điều kiện lọc theo danh mục
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }
        
        // Thêm điều kiện lọc theo trạng thái tồn kho
        if (stockStatus != null && !stockStatus.trim().isEmpty()) {
            if ("instock".equals(stockStatus)) {
                sql.append(" AND stock_quantity > 0");
            } else if ("outstock".equals(stockStatus)) {
                sql.append(" AND stock_quantity = 0");
            }
        }
        
        sql.append(" ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
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
                plant.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(plant);
            }
        }
        return list;
    }
    
    public int getTotalFilteredPlantCount(String searchKeyword, Integer categoryId, String stockStatus) 
            throws SQLException, ClassNotFoundException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Plants WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện tìm kiếm theo tên
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + searchKeyword.trim() + "%");
        }
        
        // Thêm điều kiện lọc theo danh mục
        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }
        
        // Thêm điều kiện lọc theo trạng thái tồn kho
        if (stockStatus != null && !stockStatus.trim().isEmpty()) {
            if ("instock".equals(stockStatus)) {
                sql.append(" AND stock_quantity > 0");
            } else if ("outstock".equals(stockStatus)) {
                sql.append(" AND stock_quantity = 0");
            }
        }
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}
