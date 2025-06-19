package model;

import controller.DBUtil;
import model.Plant;
import model.CartItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    private PlantDAO plantDAO = new PlantDAO();

    // Thêm cây vào giỏ hàng
    public void addToCart(int userId, int plantId, int quantity) throws SQLException, ClassNotFoundException {
        String checkSql = "SELECT * FROM Cart WHERE user_id = ? AND plant_id = ?";
        String updateSql = "UPDATE Cart SET quantity = quantity + ? WHERE user_id = ? AND plant_id = ?";
        String insertSql = "INSERT INTO Cart (user_id, plant_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBUtil.getConnection()) {
            // Kiểm tra xem cây đã có trong giỏ chưa
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, userId);
            checkPs.setInt(2, plantId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // Cập nhật số lượng
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, quantity);
                updatePs.setInt(2, userId);
                updatePs.setInt(3, plantId);
                updatePs.executeUpdate();
            } else {
                // Thêm mới mặt hàng vào giỏ
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setInt(1, userId);
                insertPs.setInt(2, plantId);
                insertPs.setInt(3, quantity);
                insertPs.executeUpdate();
            }
        }
    }

    // Lấy tất cả mặt hàng trong giỏ của người dùng
    public List<CartItem> getCartItems(int userId) throws SQLException, ClassNotFoundException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT * FROM Cart WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int plantId = rs.getInt("plant_id");
                Plant plant = plantDAO.getPlantById(plantId);
                if (plant != null) {
                    CartItem item = new CartItem(
                            rs.getInt("cart_id"),
                            rs.getInt("user_id"),
                            plantId,
                            rs.getInt("quantity"),
                            plant
                    );
                    cartItems.add(item);
                }
            }
        }
        return cartItems;
    }

    // Cập nhật số lượng mặt hàng trong giỏ
    public void updateCartItem(int userId, int plantId, int quantity) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE Cart SET quantity = ? WHERE user_id = ? AND plant_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, plantId);
            ps.executeUpdate();
        }
    }

    // Xóa mặt hàng khỏi giỏ
    public void removeCartItem(int userId, int plantId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM Cart WHERE user_id = ? AND plant_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, plantId);
            ps.executeUpdate();
        }
    }

    // Xóa toàn bộ giỏ hàng
    public void clearCart(int userId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM Cart WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
