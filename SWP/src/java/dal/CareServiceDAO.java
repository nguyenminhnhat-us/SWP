package dal;

import controller.DBUtil;
import java.math.BigDecimal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import model.CareService;

public class CareServiceDAO {

    // Lấy chi tiết 1 dịch vụ theo ID
    public CareService getServiceById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM CareServices WHERE service_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractService(rs);
                }
            }
        }
        return null;
    }

    // Lấy service_code theo service_id
    public String getServiceCodeById(int serviceId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT service_code FROM CareServices WHERE service_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("service_code");
            }
        }
        return null;
    }

    // Lấy toàn bộ dịch vụ (cho dropdown, checkbox)
public List<CareService> getAllServices() throws SQLException, ClassNotFoundException {
    List<CareService> list = new ArrayList<>();
    String sql = "SELECT * FROM CareServices";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            CareService s = new CareService();
            s.setServiceId(rs.getInt("service_id"));
            s.setName(rs.getString("name"));
            s.setDescription(rs.getString("description"));
            s.setPrice(rs.getDouble("price"));
            s.setDurationDays(rs.getInt("duration_days"));
            list.add(s);
        }
    }
    return list;
}


public BigDecimal getTotalServicePrice(List<Integer> serviceIds) throws SQLException, ClassNotFoundException {
    if (serviceIds == null || serviceIds.isEmpty()) return BigDecimal.ZERO;
    String placeholders = serviceIds.stream().map(id -> "?").collect(Collectors.joining(","));
    String sql = "SELECT SUM(price) FROM CareServices WHERE service_id IN (" + placeholders + ")";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        for (int i = 0; i < serviceIds.size(); i++) {
            stmt.setInt(i + 1, serviceIds.get(i));
        }
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        }
    }
    return BigDecimal.ZERO;
}
// Cập nhật dịch vụ
public void updateService(CareService service) throws SQLException, ClassNotFoundException {
    String sql = "UPDATE CareServices SET name=?, description=?, price=?, duration_days=? WHERE service_id=?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, service.getName());
        stmt.setString(2, service.getDescription());
        stmt.setDouble(3, service.getPrice());
        stmt.setInt(4, service.getDurationDays());
        stmt.setInt(5, service.getServiceId()); 
        stmt.executeUpdate();
    }
}

public void insertService(CareService service) throws Exception {
    String sql = "INSERT INTO CareServices (name, description, price, duration_days) VALUES (?, ?, ?, ?)";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, service.getName());
        stmt.setString(2, service.getDescription());
        stmt.setDouble(3, service.getPrice());
        stmt.setInt(4, service.getDurationDays());
        stmt.executeUpdate();
    }
}

// Xóa dịch vụ
public void deleteService(int serviceId) throws SQLException, ClassNotFoundException {
    String sql = "DELETE FROM CareServices WHERE service_id = ?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, serviceId);
        stmt.executeUpdate();
    }
}



    // Hàm hỗ trợ extract dữ liệu
private CareService extractService(ResultSet rs) throws SQLException {
    CareService service = new CareService();
    service.setServiceId(rs.getInt("service_id"));
    service.setName(rs.getString("name"));
    service.setDescription(rs.getString("description"));
    service.setPrice(rs.getDouble("price"));
    service.setDurationDays(rs.getInt("duration_days"));
    // ❌ XÓA hoặc COMMENT dòng dưới nếu không có cột service_code
    // service.setServiceCode(rs.getString("service_code"));
    return service;
}

}
