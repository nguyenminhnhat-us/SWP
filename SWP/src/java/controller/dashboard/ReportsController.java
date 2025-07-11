package controller.dashboard;

import dal.OrderDAO;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard/reports")
public class ReportsController extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra người dùng có phải admin không
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            BigDecimal totalRevenue;
            List<Order> deliveredOrders;
            Map<String, BigDecimal> revenueByDay;
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            // Nếu không có tham số lọc, lấy doanh thu và đơn hàng toàn bộ
            if (startDate == null || endDate == null || startDate.isEmpty() || endDate.isEmpty()) {
                totalRevenue = orderDAO.getTotalRevenue();
                deliveredOrders = orderDAO.getDeliveredOrders();
                // Lấy dữ liệu cho biểu đồ trong 30 ngày gần nhất (mặc định)
                java.time.LocalDate today = java.time.LocalDate.now();
                startDate = today.minusDays(30).toString();
                endDate = today.toString();
                revenueByDay = orderDAO.getRevenueByDay(startDate, endDate);
            } else {
                // Lấy doanh thu và đơn hàng theo khoảng thời gian
                totalRevenue = orderDAO.getRevenueByDateRange(startDate, endDate);
                deliveredOrders = orderDAO.getDeliveredOrdersByDateRange(startDate, endDate);
                revenueByDay = orderDAO.getRevenueByDay(startDate, endDate);
            }

            // Gửi dữ liệu đến JSP
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("deliveredOrders", deliveredOrders);
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("revenueByDay", revenueByDay);
            request.getRequestDispatcher("/dashboard/admin/reports.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu báo cáo: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/admin/reports.jsp").forward(request, response);
        }
    }
}
