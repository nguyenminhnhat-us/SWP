package controller.dashboard;

import dal.OrderDAO;
import model.Order;
import model.OrderDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/dashboard/order-history")
public class ViewOrderHistoryController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // Redirect to login if not logged in
            return;
        }

        boolean isAdmin = "admin".equalsIgnoreCase(user.getRole()); // Assuming "admin" is the role for administrators

        try {
            String orderIdParam = request.getParameter("orderId");

            if (orderIdParam != null && !orderIdParam.isEmpty()) {
                // View order details
                int orderId = Integer.parseInt(orderIdParam);
                Order order = null;
                List<OrderDetail> orderDetails = null;

                if (isAdmin) {
                    order = orderDAO.getOrderById(orderId);
                } else {
                    order = orderDAO.getOrderByIdAndUserId(orderId, user.getUserId());
                }

                if (order != null) {
                    orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);
                    request.setAttribute("order", order);
                    request.setAttribute("orderDetails", orderDetails);
                    request.getRequestDispatcher("/dashboard/order-detail.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập.");
                    request.getRequestDispatcher("/dashboard/order-history.jsp").forward(request, response);
                }

            } else {
                // View all orders or user's own orders
                List<Order> orders;
                if (isAdmin) {
                    orders = orderDAO.getAllOrders();
                } else {
                    orders = orderDAO.getOrdersByUserId(user.getUserId());
                }
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/dashboard/order-history.jsp").forward(request, response);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu đơn hàng: " + e.getMessage());
                request.getRequestDispatcher("/dashboard/order-history.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // Redirect to login if not admin
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");

            try {
                boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
                if (success) {
                    session.setAttribute("message", "Cập nhật trạng thái đơn hàng thành công.");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Cập nhật trạng thái đơn hàng thất bại.");
                    session.setAttribute("messageType", "error");
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                session.setAttribute("message", "Lỗi khi cập nhật trạng thái đơn hàng: " + e.getMessage());
                session.setAttribute("messageType", "error");
            }
            // Redirect back to the order detail page
            response.sendRedirect(request.getContextPath() + "/dashboard/order-history?orderId=" + orderId);
        } else {
            doGet(request, response); // Fallback to doGet for other actions
        }
    }
}
