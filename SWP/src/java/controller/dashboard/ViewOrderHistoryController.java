package controller.dashboard;

import dal.OrderDAO;
import dal.CareCartDAO;
import model.Order;
import model.OrderDetail;
import model.CareCart;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/dashboard/order-history")
public class ViewOrderHistoryController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();
    private CareCartDAO careCartDAO = new CareCartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        boolean isAdmin = "admin".equalsIgnoreCase(user.getRole());

        try {
            String orderIdParam = request.getParameter("orderId");

            // Nếu có orderId thì hiển thị chi tiết đơn sản phẩm
            if (orderIdParam != null && !orderIdParam.isEmpty()) {
                int orderId = Integer.parseInt(orderIdParam);
                Order order;
                List<OrderDetail> orderDetails;

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
                    return;
                } else {
                    request.setAttribute("error", "Không tìm thấy đơn hàng hoặc bạn không có quyền truy cập.");
                }
            }

            // ✅ Hiển thị danh sách đơn hàng (product order)
            List<Order> orders = isAdmin
                    ? orderDAO.getAllOrders()
                    : orderDAO.getOrdersByUserId(user.getUserId());

            // ✅ Hiển thị danh sách đơn chăm sóc cây
            List<CareCart> careCarts = isAdmin
                    ? careCartDAO.getAllCareCarts()
                    : careCartDAO.getAllCareCartsByUserId(user.getUserId());

            request.setAttribute("orders", orders);
            request.setAttribute("careCarts", careCarts); // ⚠️ Đổi tên thành careCarts

            request.getRequestDispatcher("/dashboard/order-history.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException | NumberFormatException e) {
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
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("status");

                boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
                session.setAttribute("message", success ? "Cập nhật trạng thái thành công." : "Cập nhật thất bại.");
                session.setAttribute("messageType", success ? "success" : "error");

                response.sendRedirect(request.getContextPath() + "/dashboard/order-history?orderId=" + orderId);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("message", "Lỗi khi cập nhật: " + e.getMessage());
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/dashboard/order-history");
            }
        } else {
            doGet(request, response);
        }
    }
}
