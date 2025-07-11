package dal;

import model.Order;
import model.OrderDetail;
import controller.DBUtil;
import java.sql.*;
import java.util.List;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class OrderDAO {

    public int createOrder(Order order) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Orders (user_id, total_amount, status, shipping_address, payment_method) VALUES (?, ?, ?, ?, ?)";
        int orderId = 0;
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
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

    public List<Order> getAllOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new java.util.ArrayList<>();
        String sql = "SELECT order_id, user_id, total_amount, status, shipping_address, payment_method, created_at FROM Orders ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_amount"),
                        rs.getString("status"),
                        rs.getString("shipping_address"),
                        rs.getString("payment_method"),
                        rs.getTimestamp("created_at")
                );
                orders.add(order);
            }
        }
        return orders;
    }

    public Order getOrderById(int orderId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT order_id, user_id, total_amount, status, shipping_address, payment_method, created_at FROM Orders WHERE order_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, orderId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Order(
                            rs.getInt("order_id"),
                            rs.getInt("user_id"),
                            rs.getBigDecimal("total_amount"),
                            rs.getString("status"),
                            rs.getString("shipping_address"),
                            rs.getString("payment_method"),
                            rs.getTimestamp("created_at")
                    );
                }
            }
        }
        return null;
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) throws SQLException, ClassNotFoundException {
        List<OrderDetail> orderDetails = new java.util.ArrayList<>();
        String sql = "SELECT od.order_detail_id, od.order_id, od.plant_id, od.quantity, od.unit_price, p.name AS plant_name, p.image_url FROM OrderDetails od JOIN Plants p ON od.plant_id = p.plant_id WHERE od.order_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, orderId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = new OrderDetail(
                            rs.getInt("order_detail_id"),
                            rs.getInt("order_id"),
                            rs.getInt("plant_id"),
                            rs.getInt("quantity"),
                            rs.getBigDecimal("unit_price")
                    );

                    orderDetails.add(detail);
                }
            }
        }
        return orderDetails;
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException, ClassNotFoundException {
        List<Order> orders = new java.util.ArrayList<>();
        String sql = "SELECT order_id, user_id, total_amount, status, shipping_address, payment_method, created_at FROM Orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order(
                            rs.getInt("order_id"),
                            rs.getInt("user_id"),
                            rs.getBigDecimal("total_amount"),
                            rs.getString("status"),
                            rs.getString("shipping_address"),
                            rs.getString("payment_method"),
                            rs.getTimestamp("created_at")
                    );
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    public Order getOrderByIdAndUserId(int orderId, int userId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT order_id, user_id, total_amount, status, shipping_address, payment_method, created_at FROM Orders WHERE order_id = ? AND user_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, orderId);
            st.setInt(2, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Order(
                            rs.getInt("order_id"),
                            rs.getInt("user_id"),
                            rs.getBigDecimal("total_amount"),
                            rs.getString("status"),
                            rs.getString("shipping_address"),
                            rs.getString("payment_method"),
                            rs.getTimestamp("created_at")
                    );
                }
            }
        }
        return null;
    }

    public boolean hasUserPurchasedPlant(int userId, int plantId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(od.order_id) FROM OrderDetails od JOIN Orders o ON od.order_id = o.order_id WHERE o.user_id = ? AND od.plant_id = ? AND o.status = 'delivered'";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, plantId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public int getOrderIdForUserAndPlant(int userId, int plantId) throws SQLException, ClassNotFoundException {
        // Get the latest order ID where the user purchased this plant and the order is delivered
        String sql = "SELECT TOP 1 od.order_id FROM OrderDetails od JOIN Orders o ON od.order_id = o.order_id WHERE o.user_id = ? AND od.plant_id = ? AND o.status = 'delivered' ORDER BY o.created_at DESC";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, plantId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("order_id");
                }
            }
        }
        return -1; // Return -1 if not found
    }

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        OrderDAO o = new OrderDAO();
        System.out.println(o.hasUserPurchasedPlant(2, 9));
    }

    public boolean updateOrderStatus(int orderId, String newStatus) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, newStatus);
            st.setInt(2, orderId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Lấy tổng doanh thu từ các đơn hàng có trạng thái delivered
    public BigDecimal getTotalRevenue() throws SQLException, ClassNotFoundException {
        String sql = "SELECT SUM(total_amount) AS total_revenue FROM Orders WHERE status = 'delivered'";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("total_revenue") != null ? rs.getBigDecimal("total_revenue") : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }

    // Lấy doanh thu theo khoảng thời gian
    public BigDecimal getRevenueByDateRange(String startDate, String endDate) throws SQLException, ClassNotFoundException {
        String sql = "SELECT SUM(total_amount) AS total_revenue FROM Orders WHERE status = 'delivered' AND created_at BETWEEN ? AND ?";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, startDate + " 00:00:00");
            st.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_revenue") != null ? rs.getBigDecimal("total_revenue") : BigDecimal.ZERO;
                }
            }
        }
        return BigDecimal.ZERO;
    }

    // Lấy danh sách đơn hàng đã giao
    public List<Order> getDeliveredOrders() throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, user_id, total_amount, status, shipping_address, payment_method, created_at "
                + "FROM Orders WHERE status = 'delivered' ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_amount"),
                        rs.getString("status"),
                        rs.getString("shipping_address"),
                        rs.getString("payment_method"),
                        rs.getTimestamp("created_at")
                );
                orders.add(order);
            }
        }
        return orders;
    }

    // Lấy danh sách đơn hàng đã giao trong khoảng thời gian
    public List<Order> getDeliveredOrdersByDateRange(String startDate, String endDate) throws SQLException, ClassNotFoundException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, user_id, total_amount, status, shipping_address, payment_method, created_at "
                + "FROM Orders WHERE status = 'delivered' AND created_at BETWEEN ? AND ? ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection(); PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, startDate + " 00:00:00");
            st.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order(
                            rs.getInt("order_id"),
                            rs.getInt("user_id"),
                            rs.getBigDecimal("total_amount"),
                            rs.getString("status"),
                            rs.getString("shipping_address"),
                            rs.getString("payment_method"),
                            rs.getTimestamp("created_at")
                    );
                    orders.add(order);
                }
            }
        }
        return orders;
    }
    
    public Map<String, BigDecimal> getRevenueByDay(String startDate, String endDate) throws SQLException, ClassNotFoundException {
        Map<String, BigDecimal> revenueByDay = new HashMap<>();
        String sql = "SELECT CAST(created_at AS DATE) AS revenue_date, SUM(total_amount) AS daily_revenue " +
                     "FROM Orders WHERE status = 'delivered' AND created_at BETWEEN ? AND ? " +
                     "GROUP BY CAST(created_at AS DATE) ORDER BY revenue_date";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement st = con.prepareStatement(sql)) {
            st.setString(1, startDate + " 00:00:00");
            st.setString(2, endDate + " 23:59:59");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    String date = rs.getString("revenue_date");
                    BigDecimal revenue = rs.getBigDecimal("daily_revenue") != null ? rs.getBigDecimal("daily_revenue") : BigDecimal.ZERO;
                    revenueByDay.put(date, revenue);
                }
            }
        }
        return revenueByDay;
    }
}
