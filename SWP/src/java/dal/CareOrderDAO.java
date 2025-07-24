package model;

import controller.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.time.*;
import java.util.ArrayList;
import java.util.List;

public class CareOrderDAO {

    // Thêm đơn chăm sóc cây và trả về care_order_id
    public static int insertCareOrder(CareOrder order) throws Exception {
        String sql = "INSERT INTO CareOrders (user_id, plant_name, drop_off_date, appointment_time, location_type, home_address, status, notes, total_price, hours_per_day, care_dates, expert_id, service_id) " +
                     "OUTPUT INSERTED.care_order_id " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, order.getUserId());
            stmt.setString(2, order.getPlantName());
            stmt.setDate(3, Date.valueOf(order.getDropOffDate()));
            stmt.setTime(4, order.getAppointmentTime() != null ? Time.valueOf(order.getAppointmentTime()) : null);
            stmt.setString(5, order.getLocationType());
            stmt.setString(6, order.getHomeAddress());
            stmt.setString(7, order.getStatus());
            stmt.setString(8, order.getNotes());
            stmt.setBigDecimal(9, order.getTotalPrice());
            stmt.setInt(10, order.getHoursPerDay());
            stmt.setString(11, order.getCareDates());
            stmt.setInt(12, order.getExpertId());
            stmt.setInt(13, order.getServiceId());

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        throw new SQLException("❌ Không thể thêm đơn chăm sóc cây.");
    }

    // Thêm danh sách ngày chăm cây vào CareOrderDays
    public static void insertCareDays(int careOrderId, List<String> selectedDays) throws Exception {
        String sql = "INSERT INTO CareOrderDays (care_order_id, care_date) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (String day : selectedDays) {
                stmt.setInt(1, careOrderId);
                stmt.setDate(2, Date.valueOf(day));
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    // Thêm danh sách dịch vụ đã chọn vào CareOrderServices
    public static void insertCareServices(int careOrderId, List<Integer> serviceIds) throws Exception {
        String sql = "INSERT INTO CareOrderServices (care_order_id, service_code) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (Integer id : serviceIds) {
                String code = getServiceCodeById(id, conn); // lấy service_code từ bảng CareServices
                stmt.setInt(1, careOrderId);
                stmt.setString(2, code);
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    // Lấy service_code từ CareServices theo service_id
    private static String getServiceCodeById(int serviceId, Connection conn) throws SQLException {
        String sql = "SELECT service_code FROM CareServices WHERE service_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("service_code");
            }
        }
        throw new SQLException("Không tìm thấy service_code cho service_id = " + serviceId);
    }

    // ✅ Chuyên gia duyệt hoặc từ chối đơn chăm sóc
    public static void updateCareOrderStatus(int careOrderId, String status, boolean accepted) throws ClassNotFoundException {
        String sql = "UPDATE CareOrders SET status = ?, is_accepted_by_expert = ? WHERE care_order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setBoolean(2, accepted);
            ps.setInt(3, careOrderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Lấy đơn được giao cho chuyên gia
    public static List<CareOrder> getCareOrdersByExpertId(int expertId) throws ClassNotFoundException {
        List<CareOrder> careOrders = new ArrayList<>();
        String sql = "SELECT * FROM CareOrders WHERE expert_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, expertId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CareOrder order = new CareOrder();
                order.setCareOrderId(rs.getInt("care_order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setExpertId(rs.getInt("expert_id"));
                order.setServiceId(rs.getInt("service_id"));
                order.setPlantName(rs.getString("plant_name"));

                Date dropDate = rs.getDate("drop_off_date");
                if (dropDate != null) {
                    order.setDropOffDate(dropDate.toLocalDate());
                }

                Time time = rs.getTime("appointment_time");
                if (time != null) {
                    order.setAppointmentTime(time.toLocalTime());
                }

                order.setLocationType(rs.getString("location_type"));
                order.setHomeAddress(rs.getString("home_address"));
                order.setStatus(rs.getString("status"));
                order.setNotes(rs.getString("notes"));
                order.setTotalPrice(rs.getBigDecimal("total_price"));
                order.setHoursPerDay(rs.getInt("hours_per_day"));
                order.setCareDates(rs.getString("care_dates"));

                Timestamp created = rs.getTimestamp("created_at");
                if (created != null) {
                    order.setCreatedAt(created.toLocalDateTime());
                }

                order.setAcceptedByExpert(rs.getBoolean("is_accepted_by_expert"));

                careOrders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return careOrders;
    }
public void insertFromCareCart(CareCart cart) throws SQLException, ClassNotFoundException {
    String sql = "INSERT INTO CareOrders (user_id, service_id, plant_name, drop_off_date, notes, status, created_at, location_type, home_address, appointment_time, hours_per_day, total_price) " +
                 "VALUES (?, NULL, ?, ?, ?, 'in_progress', SYSDATETIME(), ?, ?, ?, ?, ?)";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, cart.getUserId());
        ps.setString(2, cart.getPlantName());
        ps.setDate(3, cart.getDropOffDate());
        ps.setString(4, cart.getNotes());
        ps.setString(5, cart.getLocationType());
        ps.setString(6, cart.getHomeAddress());
        ps.setTime(7, cart.getAppointmentTime());
        ps.setInt(8, cart.getHoursPerDay());
        ps.setBigDecimal(9, cart.getTotalPrice());
        ps.executeUpdate();
    }
}

    // ✅ Tính tổng giá dịch vụ theo combo
    public static double calculateTotalPriceByServiceCombo(List<Integer> serviceIds) throws Exception {
        if (serviceIds == null || serviceIds.isEmpty()) return 0;
        String inClause = String.join(",", serviceIds.stream().map(String::valueOf).toArray(String[]::new));
        String sql = "SELECT SUM(price) FROM CareServices WHERE service_id IN (" + inClause + ")";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        }
        return 0;
    }
}
