package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import controller.DBUtil;

public class CareCartServicesDAO {

    public void addCareCartService(int cartId, int serviceId) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO CareCartServices (cart_id, service_id) VALUES (?, ?)";
        
        try (Connection conn = DBUtil.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.setInt(2, serviceId);
            stmt.executeUpdate();
        }
    }
}