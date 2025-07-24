package dal;

import controller.DBUtil;
import model.Consultation;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


public class ConsultationDAO {

    public List<Consultation> getConsultationsByUserId(int userId) {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM Consultations WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractConsultation(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Consultation> getConsultationsByExpertId(int expertId) {
        List<Consultation> list = new ArrayList<>();
        String sql = "SELECT * FROM Consultations WHERE expert_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, expertId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractConsultation(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Consultation getConsultationById(int id) {
        String sql = "SELECT * FROM Consultations WHERE consultation_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractConsultation(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     public boolean isUserInConsultation(int consultationId, int userId) {
        String sql = "SELECT * FROM Consultations WHERE consultation_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, consultationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int user = rs.getInt("user_id");
                    int expert = rs.getInt("expert_id");
                    return userId == user || userId == expert;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Consultation extractConsultation(ResultSet rs) throws SQLException {
        Consultation c = new Consultation();
        c.setConsultationId(rs.getInt("consultation_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setExpertId(rs.getInt("expert_id"));
        c.setAppointmentDate(rs.getDate("appointment_date").toLocalDate());
        c.setAppointmentTime(rs.getTime("appointment_time").toLocalTime());
        c.setHomeAddress(rs.getString("home_address"));
        c.setLocationType(rs.getString("location_type"));
        c.setIssueDescription(rs.getString("issue_description"));
        c.setStatus(rs.getString("status"));
        c.setAcceptedByExpert(rs.getBoolean("is_accepted_by_expert"));
        c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return c;
    }
}
