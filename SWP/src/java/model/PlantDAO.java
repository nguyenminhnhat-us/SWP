package model;


import controller.DBUtil;
import model.Plant;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlantDAO {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=plant_care_systemcu;encrypt=true;trustServerCertificate=true";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "minhnhat1234";

    public List<Plant> getAllPlants() {
        List<Plant> plants = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM Plants")) {
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
                plants.add(plant);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plants;
    }

    public Plant getPlantById(int plantId) {
        Plant plant = null;
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Plants WHERE plant_id = ?")) {
            pstmt.setInt(1, plantId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                plant = new Plant(
                    rs.getInt("plant_id"),
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image_url")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return plant;
    }
    public List<Plant> getPlantsByCategory(int categoryId) {
    List<Plant> plantList = new ArrayList<>();
    String sql = "SELECT * FROM Plants WHERE category_id = ?";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

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


}