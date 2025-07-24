package controller.dashboard;

import dal.OrderDAO;
import dal.CareCartDAO;
import model.Order;
import model.CareCart;
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
    private CareCartDAO careCartDAO = new CareCartDAO(); // ✅ Thêm DAO chăm sóc cây

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // ✅ Chỉ cho phép admin truy cập
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            // Đơn sản phẩm
            BigDecimal totalRevenue;
            List<Order> deliveredOrders;
            Map<String, BigDecimal> revenueByDay;

            // Đơn chăm sóc cây
            BigDecimal totalCareRevenue;
            List<CareCart> deliveredCareCarts;
            Map<String, BigDecimal> careRevenueByDay;

            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            if (startDate == null || endDate == null || startDate.isEmpty() || endDate.isEmpty()) {
                java.time.LocalDate today = java.time.LocalDate.now();
                startDate = today.minusDays(30).toString();
                endDate = today.toString();
            }

            // ✅ Lấy báo cáo sản phẩm
            totalRevenue = orderDAO.getRevenueByDateRange(startDate, endDate);
            deliveredOrders = orderDAO.getDeliveredOrdersByDateRange(startDate, endDate);
            revenueByDay = orderDAO.getRevenueByDay(startDate, endDate);

            // ✅ Lấy báo cáo chăm sóc cây
            totalCareRevenue = careCartDAO.getTotalCareRevenueByDateRange(startDate, endDate);
            deliveredCareCarts = careCartDAO.getCompletedCareCartsByDateRange(startDate, endDate);
            careRevenueByDay = careCartDAO.getCareRevenueByDay(startDate, endDate);

            // ✅ Set dữ liệu cho JSP
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            // Sản phẩm
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("deliveredOrders", deliveredOrders);
            request.setAttribute("revenueByDay", revenueByDay);

            // Chăm sóc cây
            request.setAttribute("totalCareRevenue", totalCareRevenue);
            request.setAttribute("deliveredCareCarts", deliveredCareCarts);
            request.setAttribute("careRevenueByDay", careRevenueByDay);

            request.getRequestDispatcher("/dashboard/admin/reports.jsp").forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu báo cáo: " + e.getMessage());
            request.getRequestDispatcher("/dashboard/admin/reports.jsp").forward(request, response);
        }
    }
}
