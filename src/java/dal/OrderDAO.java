package dal;

import model.Order;
import model.OrderDetail;
import controller.DBUtil;
import java.sql.*;
import java.util.List;
import java.math.BigDecimal;

public class OrderDAO {

    public int createOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Orders (user_id, total_amount, status, shipping_address, payment_method) VALUES (?, ?, ?, ?, ?)";
        int orderId = 0;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, order.getUserId());
            st.setBigDecimal(2, order.getTotalAmount());
            st.setString(3, order.getStatus());
            st.setString(4, order.getShippingAddress());
            st.setString(5, order.getPaymentMethod());
            st.executeUpdate();

            try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                }
            }
        }
        return orderId;
    }

    public void createOrderDetails(int orderId, List<OrderDetail> orderDetails) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO OrderDetails (order_id, plant_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            for (OrderDetail detail : orderDetails) {
                st.setInt(1, orderId);
                st.setInt(2, detail.getPlantId());
                st.setInt(3, detail.getQuantity());
                st.setBigDecimal(4, detail.getUnitPrice());
                st.addBatch();
            }
            st.executeBatch();
        }
    }
}
