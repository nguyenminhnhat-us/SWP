package dal;

import java.sql.*;
import java.util.*;
import model.Review;
import controller.DBUtil;

public class ReviewDAO {

    public List<Review> getReviewsByPlantId(int plantId) throws SQLException, ClassNotFoundException {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name FROM Reviews r JOIN Users u ON r.user_id = u.user_id WHERE r.plant_id = ? ORDER BY r.created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, plantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setPlantId(rs.getInt("plant_id"));
                r.setOrderId(rs.getInt("order_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserName(rs.getString("full_name")); // Set userName
                list.add(r);
            }
        }
        return list;
    }
    
    public void addReview(Review review) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Reviews (user_id, plant_id, order_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, review.getUserId());
            ps.setInt(2, review.getPlantId());
            ps.setInt(3, review.getOrderId());
            ps.setInt(4, review.getRating());
            ps.setString(5, review.getComment());
            ps.executeUpdate();
        }
    }
}
