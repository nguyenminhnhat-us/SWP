package dal;

import controller.DBUtil;
import model.Message;
import java.sql.*;

public class MessageDAO {
    public static void saveMessage(Message msg) {
        String sql = "INSERT INTO Messages (consultation_id, sender_id, receiver_id, content, sent_at) VALUES (?, ?, ?, ?, GETDATE())";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, msg.getConsultationId());
            ps.setInt(2, msg.getSenderId());
            ps.setInt(3, msg.getReceiverId());
            ps.setString(4, msg.getContent());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
