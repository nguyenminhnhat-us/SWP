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
                // Lấy tên user
                // Nếu cần lấy tên plant, có thể gọi PlantDAO ở đây và set vào Review (nếu entity có trường đó)
                list.add(r);
            }
        }
        return list;
    }
    
}
