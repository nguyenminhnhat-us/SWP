package dal;

import controller.DBUtil;
import java.math.BigDecimal;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.CareCart;
import model.CareService;
import model.Order;

public class CareCartDAO {

    public int addCareCart(int userId, String plantName, String dropOffDate, String appointmentTime,
                           String locationType, String homeAddress, int expertId, int hoursPerDay,
                           String notes, double totalPrice) throws SQLException, ParseException, ClassNotFoundException {

        String sql = "INSERT INTO CareCart (user_id, plant_name, drop_off_date, appointment_time, " +
                     "location_type, home_address, expert_id, hours_per_day, notes, total_price, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, userId);
            stmt.setString(2, plantName);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            stmt.setDate(3, new java.sql.Date(sdf.parse(dropOffDate).getTime()));
            stmt.setString(4, appointmentTime);
            stmt.setString(5, locationType);
            stmt.setString(6, homeAddress != null ? homeAddress : null);
            stmt.setInt(7, expertId);
            stmt.setInt(8, hoursPerDay);
            stmt.setString(9, notes != null ? notes : null);
            stmt.setDouble(10, totalPrice);

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            throw new SQLException("Không thể lấy cart_id sau khi thêm.");
        }
    }

    public BigDecimal getTotalServicePrice(List<Integer> serviceIds) throws SQLException, ClassNotFoundException {
        if (serviceIds == null || serviceIds.isEmpty()) {
            return BigDecimal.ZERO;
        }

        StringBuilder sql = new StringBuilder("SELECT SUM(price) FROM CareServices WHERE service_id IN (");
        for (int i = 0; i < serviceIds.size(); i++) {
            sql.append("?");
            if (i < serviceIds.size() - 1) {
                sql.append(", ");
            }
        }
        sql.append(")");

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < serviceIds.size(); i++) {
                ps.setInt(i + 1, serviceIds.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal(1) != null ? rs.getBigDecimal(1) : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    public void insertCartWithServices(int userId, String plantName, String dropOffDate, String appointmentTime,
                                       String locationType, String homeAddress, int expertId, int hoursPerDay,
                                       String notes, BigDecimal totalPrice, List<Integer> serviceIds)
            throws SQLException, ParseException, ClassNotFoundException {

        if (serviceIds == null || serviceIds.isEmpty()) {
            throw new IllegalArgumentException("Danh sách dịch vụ không được để trống");
        }

        Connection conn = null;
        PreparedStatement cartStmt = null;
        PreparedStatement serviceStmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String cartSql = "INSERT INTO CareCart (user_id, plant_name, drop_off_date, appointment_time, " +
                             "location_type, home_address, expert_id, hours_per_day, notes, total_price, created_at) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATETIME())";

            cartStmt = conn.prepareStatement(cartSql, PreparedStatement.RETURN_GENERATED_KEYS);
            cartStmt.setInt(1, userId);
            cartStmt.setString(2, plantName);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            cartStmt.setDate(3, new java.sql.Date(sdf.parse(dropOffDate).getTime()));
            cartStmt.setString(4, appointmentTime);
            cartStmt.setString(5, locationType);
            cartStmt.setString(6, homeAddress != null ? homeAddress : "");
            cartStmt.setInt(7, expertId);
            cartStmt.setInt(8, hoursPerDay);
            cartStmt.setString(9, notes != null ? notes : "");
            cartStmt.setBigDecimal(10, totalPrice);

            cartStmt.executeUpdate();

            rs = cartStmt.getGeneratedKeys();
            int cartId;
            if (rs.next()) {
                cartId = rs.getInt(1);
            } else {
                throw new SQLException("Không thể lấy cart_id sau khi insert.");
            }

            String serviceSql = "INSERT INTO CareCartServices (cart_id, service_id) VALUES (?, ?)";
            serviceStmt = conn.prepareStatement(serviceSql);
            for (Integer sid : serviceIds) {
                serviceStmt.setInt(1, cartId);
                serviceStmt.setInt(2, sid);
                serviceStmt.addBatch();
            }
            serviceStmt.executeBatch();

            conn.commit();

        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw new SQLException("Lỗi khi lưu giỏ hàng: " + e.getMessage(), e);

        } finally {
            if (rs != null) rs.close();
            if (cartStmt != null) cartStmt.close();
            if (serviceStmt != null) serviceStmt.close();
            if (conn != null) conn.setAutoCommit(true);
            if (conn != null) conn.close();
        }
    }

    public List<CareCart> getAllCareCartsByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<CareCart> cartList = new ArrayList<>();
        String sql = "SELECT * FROM CareCart WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CareCart cart = new CareCart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setExpertId(rs.getInt("expert_id"));
                cart.setPlantName(rs.getString("plant_name"));
                cart.setDropOffDate(rs.getDate("drop_off_date"));
                cart.setAppointmentTime(rs.getTime("appointment_time"));
                cart.setLocationType(rs.getString("location_type"));
                cart.setHomeAddress(rs.getString("home_address"));
                cart.setHoursPerDay(rs.getInt("hours_per_day"));
                cart.setNotes(rs.getString("notes"));
                cart.setTotalPrice(rs.getBigDecimal("total_price"));
                cart.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                cart.setStatus(rs.getString("status"));
                cartList.add(cart);
            }
        }

        return cartList;
    }

    public CareCart getCareCartById(int cartId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM CareCart WHERE cart_id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                CareCart cart = new CareCart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setPlantName(rs.getString("plant_name"));
                cart.setDropOffDate(rs.getDate("drop_off_date"));
                cart.setAppointmentTime(rs.getTime("appointment_time"));
                cart.setLocationType(rs.getString("location_type"));
                cart.setHomeAddress(rs.getString("home_address"));
                cart.setExpertId(rs.getInt("expert_id"));
                cart.setHoursPerDay(rs.getInt("hours_per_day"));
                cart.setNotes(rs.getString("notes"));
                cart.setTotalPrice(rs.getBigDecimal("total_price"));
                cart.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                cart.setStatus(rs.getString("status"));
                return cart;
            }
        }
        return null;
    }

    public List<CareService> getServicesByCartId(int cartId) throws SQLException, ClassNotFoundException {
        List<CareService> services = new ArrayList<>();
        String sql = "SELECT cs.service_id, cs.name, cs.description, cs.price, cs.duration_days " +
                     "FROM CareCartServices ccs " +
                     "JOIN CareServices cs ON ccs.service_id = cs.service_id " +
                     "WHERE ccs.cart_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CareService service = new CareService();
                service.setServiceId(rs.getInt("service_id"));
                service.setName(rs.getString("name"));
                service.setDescription(rs.getString("description"));
                service.setPrice(rs.getDouble("price"));
                service.setDurationDays(rs.getInt("duration_days"));
                services.add(service);
            }
        }
        return services;
    }

    public void deleteCartById(int cartId) throws SQLException, ClassNotFoundException {
        String deleteServicesSql = "DELETE FROM CareCartServices WHERE cart_id = ?";
        String deleteCartSql = "DELETE FROM CareCart WHERE cart_id = ?";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(deleteServicesSql);
                 PreparedStatement ps2 = conn.prepareStatement(deleteCartSql)) {

                ps1.setInt(1, cartId);
                ps1.executeUpdate();

                ps2.setInt(1, cartId);
                ps2.executeUpdate();

                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public void updateCareCart(int cartId, String plantName, String dropOffDate, String appointmentTime,
                               String locationType, String homeAddress, String notes, int hoursPerDay,
                               List<Integer> serviceIds) throws SQLException, ParseException, ClassNotFoundException {

        if (serviceIds == null || serviceIds.isEmpty()) {
            throw new IllegalArgumentException("Đơn hàng phải chọn ít nhất một dịch vụ chăm sóc.");
        }

        Connection conn = null;
        PreparedStatement updateCart = null;
        PreparedStatement deleteOld = null;
        PreparedStatement insertNew = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String updateSql = "UPDATE CareCart SET plant_name=?, drop_off_date=?, appointment_time=?, " +
                               "location_type=?, home_address=?, notes=?, hours_per_day=? WHERE cart_id=?";
            updateCart = conn.prepareStatement(updateSql);
            updateCart.setString(1, plantName);
            updateCart.setDate(2, java.sql.Date.valueOf(dropOffDate));
            updateCart.setTime(3, java.sql.Time.valueOf(appointmentTime));
            updateCart.setString(4, locationType);
            updateCart.setString(5, homeAddress);
            updateCart.setString(6, notes);
            updateCart.setInt(7, hoursPerDay);
            updateCart.setInt(8, cartId);
            updateCart.executeUpdate();

            deleteOld = conn.prepareStatement("DELETE FROM CareCartServices WHERE cart_id = ?");
            deleteOld.setInt(1, cartId);
            deleteOld.executeUpdate();

            insertNew = conn.prepareStatement("INSERT INTO CareCartServices(cart_id, service_id) VALUES (?, ?)");
            for (Integer sid : serviceIds) {
                insertNew.setInt(1, cartId);
                insertNew.setInt(2, sid);
                insertNew.addBatch();
            }
            insertNew.executeBatch();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (updateCart != null) updateCart.close();
            if (deleteOld != null) deleteOld.close();
            if (insertNew != null) insertNew.close();
            if (conn != null) conn.setAutoCommit(true);
            if (conn != null) conn.close();
        }
    }

public List<CareCart> getCartsByExpertId(int expertId) throws SQLException, ClassNotFoundException {
    List<CareCart> list = new ArrayList<>();
    String sql = "SELECT * FROM CareCart WHERE expert_id = ?";

    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, expertId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            try {
                CareCart cart = new CareCart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setExpertId(rs.getInt("expert_id"));
                cart.setPlantName(rs.getString("plant_name"));
                cart.setDropOffDate(rs.getDate("drop_off_date"));

                // ✅ Fix: đảm bảo an toàn khi đọc appointment_time kiểu datetime
                Timestamp ts = rs.getTimestamp("appointment_time");
                if (ts != null) {
                    cart.setAppointmentTime(new Time(ts.getTime()));
                }

                cart.setLocationType(rs.getString("location_type"));
                cart.setHomeAddress(rs.getString("home_address"));
                cart.setHoursPerDay(rs.getInt("hours_per_day"));
                cart.setNotes(rs.getString("notes"));
                cart.setTotalPrice(rs.getBigDecimal("total_price"));

                Timestamp created = rs.getTimestamp("created_at");
                if (created != null) {
                    cart.setCreatedAt(created.toLocalDateTime());
                }

                cart.setStatus(rs.getString("status"));
                list.add(cart);

                // Debug từng đơn
                System.out.println("🟢 Đơn tìm thấy: cart_id = " + cart.getCartId());

            } catch (Exception e) {
                System.out.println("❌ Lỗi parse đơn: " + e.getMessage());
            }
        }
    }

    return list;
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
public List<CareCart> getPaidCareCartsByUserId(int userId) throws SQLException, ClassNotFoundException {
    List<CareCart> carts = new ArrayList<>();
    String sql = "SELECT * FROM CareCart WHERE user_id = ? AND status IN ('in_progress', 'completed') ORDER BY created_at DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            CareCart cart = new CareCart();
            cart.setCartId(rs.getInt("cart_id"));
            cart.setUserId(rs.getInt("user_id"));
            cart.setPlantName(rs.getString("plant_name"));
            cart.setDropOffDate(rs.getDate("drop_off_date"));
            cart.setAppointmentTime(rs.getTime("appointment_time"));
            cart.setLocationType(rs.getString("location_type"));
            cart.setHomeAddress(rs.getString("home_address"));
            cart.setExpertId(rs.getInt("expert_id"));
            cart.setHoursPerDay(rs.getInt("hours_per_day"));
            cart.setNotes(rs.getString("notes"));
            cart.setTotalPrice(rs.getBigDecimal("total_price"));
            Timestamp createdAt = rs.getTimestamp("created_at");
            cart.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
            cart.setStatus(rs.getString("status"));
            carts.add(cart);
        }
    }
    return carts;
}


    public boolean updateCartStatus(int cartId, String status) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE CareCart SET status = ? WHERE cart_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, cartId);

            int rows = stmt.executeUpdate();
            System.out.println("Update rows: " + rows);
            return rows > 0;
        }
    }
    public List<CareCart> getAssignedScheduleByExpert(int expertId) throws SQLException, ClassNotFoundException {
    String sql = "SELECT cart_id, plant_name, drop_off_date, appointment_time, status " +
                 "FROM CareCart WHERE expert_id = ? AND status IN ('approved', 'in_progress') ORDER BY drop_off_date";

    List<CareCart> schedule = new ArrayList<>();
    try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, expertId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            CareCart c = new CareCart();
            c.setCartId(rs.getInt("cart_id"));
            c.setPlantName(rs.getString("plant_name"));
            c.setDropOffDate(rs.getDate("drop_off_date"));
            c.setAppointmentTime(rs.getTime("appointment_time"));
            c.setStatus(rs.getString("status"));
            schedule.add(c);
        }
    }
    return schedule;
}
public List<CareCart> getCompletedCareCartsByUserId(int userId) throws ClassNotFoundException {
    List<CareCart> completedCarts = new ArrayList<>();
    String sql = "SELECT * FROM CareCart WHERE user_id = ? AND status = 'completed'";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            CareCart cart = new CareCart();
            cart.setCartId(rs.getInt("cart_id"));
            cart.setUserId(rs.getInt("user_id"));
            cart.setPlantName(rs.getString("plant_name"));
            cart.setDropOffDate(rs.getDate("drop_off_date"));
            cart.setAppointmentTime(rs.getTime("appointment_time"));
            cart.setLocationType(rs.getString("location_type"));
            cart.setHomeAddress(rs.getString("home_address"));
            cart.setExpertId(rs.getInt("expert_id"));
            cart.setHoursPerDay(rs.getInt("hours_per_day"));
            cart.setNotes(rs.getString("notes"));
            cart.setTotalPrice(rs.getBigDecimal("total_price"));
            Timestamp createdAtTs = rs.getTimestamp("created_at");
            cart.setCreatedAt(createdAtTs != null ? createdAtTs.toLocalDateTime() : null);
            cart.setStatus(rs.getString("status"));

            completedCarts.add(cart);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return completedCarts;
}
public List<CareCart> getAllCareCarts() throws SQLException, ClassNotFoundException {
    List<CareCart> carts = new ArrayList<>();
    String sql = "SELECT * FROM CareCart ORDER BY created_at DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            CareCart cart = new CareCart();
            cart.setCartId(rs.getInt("cart_id"));
            cart.setUserId(rs.getInt("user_id"));
            cart.setPlantName(rs.getString("plant_name"));
            cart.setDropOffDate(rs.getDate("drop_off_date"));
            cart.setAppointmentTime(rs.getTime("appointment_time"));
            cart.setLocationType(rs.getString("location_type"));
            cart.setHomeAddress(rs.getString("home_address"));
            cart.setExpertId(rs.getInt("expert_id"));
            cart.setHoursPerDay(rs.getInt("hours_per_day"));
            cart.setNotes(rs.getString("notes"));
            cart.setTotalPrice(rs.getBigDecimal("total_price"));
            Timestamp createdAt = rs.getTimestamp("created_at");
            cart.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
            cart.setStatus(rs.getString("status"));
            carts.add(cart);
        }
    }
    return carts;
}
public BigDecimal getTotalCareRevenueByDateRange(String startDate, String endDate) throws SQLException, ClassNotFoundException {
    String sql = "SELECT SUM(total_price) AS total FROM CareCart WHERE status = 'completed' AND drop_off_date BETWEEN ? AND ?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, startDate);
        ps.setString(2, endDate);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("total") != null ? rs.getBigDecimal("total") : BigDecimal.ZERO;
            }
        }
    }
    return BigDecimal.ZERO;
}
public List<CareCart> getCompletedCareCartsByDateRange(String startDate, String endDate) throws SQLException, ClassNotFoundException {
    List<CareCart> list = new ArrayList<>();
    String sql = "SELECT * FROM CareCart WHERE status = 'completed' AND drop_off_date BETWEEN ? AND ? ORDER BY drop_off_date DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, startDate);
        ps.setString(2, endDate);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CareCart cart = new CareCart();
                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setPlantName(rs.getString("plant_name"));
                cart.setDropOffDate(rs.getDate("drop_off_date")); // ✅ Chính xác
                cart.setAppointmentTime(rs.getTime("appointment_time")); // ✅ Không cần xử lý gì thêm
                cart.setLocationType(rs.getString("location_type"));
                cart.setHomeAddress(rs.getString("home_address"));
                cart.setNotes(rs.getString("notes"));
                cart.setHoursPerDay(rs.getInt("hours_per_day"));
                cart.setTotalPrice(rs.getBigDecimal("total_price"));
                cart.setStatus(rs.getString("status"));
                list.add(cart);
            }
        }
    }
    return list;
}
public Map<String, BigDecimal> getCareRevenueByDay(String startDate, String endDate) throws SQLException, ClassNotFoundException {
    Map<String, BigDecimal> revenueMap = new LinkedHashMap<>();
    String sql = "SELECT CONVERT(VARCHAR, drop_off_date, 23) AS day, SUM(total_price) AS total " +
                 "FROM CareCart WHERE status = 'completed' AND drop_off_date BETWEEN ? AND ? " +
                 "GROUP BY CONVERT(VARCHAR, drop_off_date, 23) ORDER BY day ASC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, startDate);
        ps.setString(2, endDate);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String day = rs.getString("day");
                BigDecimal total = rs.getBigDecimal("total");
                revenueMap.put(day, total != null ? total : BigDecimal.ZERO);
            }
        }
    }
    return revenueMap;
}


}
