package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/save-care-cart")
public class CareBookingServlet extends HttpServlet {

    private final CareCartDAO cartDAO = new CareCartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String plantName = request.getParameter("plantName");
            String dropOffDate = request.getParameter("dropOffDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String locationType = request.getParameter("locationType");
            String homeAddress = request.getParameter("homeAddress");
            String notes = request.getParameter("notes");

            // Kiểm tra expertId hợp lệ
            String expertRaw = request.getParameter("expertId");
            if (expertRaw == null || expertRaw.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu expertId");
            }
            int expertId = Integer.parseInt(expertRaw);

            // Kiểm tra hoursPerDay
            String hoursRaw = request.getParameter("hoursPerDay");
            int hoursPerDay = (hoursRaw != null && !hoursRaw.isEmpty()) ? Integer.parseInt(hoursRaw) : 0;

            // Kiểm tra totalPrice
            String totalRaw = request.getParameter("totalPrice");
            if (totalRaw == null || totalRaw.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu totalPrice");
            }
            BigDecimal totalPrice = new BigDecimal(totalRaw);

            // Parse danh sách dịch vụ
            String[] serviceIdStrings = request.getParameterValues("serviceIds");
            List<Integer> serviceIds = new ArrayList<>();
            if (serviceIdStrings != null) {
                for (String idStr : serviceIdStrings) {
                    serviceIds.add(Integer.parseInt(idStr));
                }
            }

            // Lưu vào DB
            cartDAO.insertCartWithServices(
                user.getUserId(),
                plantName,
                dropOffDate,
                appointmentTime,
                locationType,
                homeAddress,
                expertId,
                hoursPerDay,
                notes,
                totalPrice,
                serviceIds
            );

            response.sendRedirect("care-cart.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3 style='color:red;'>❌ Lỗi lưu giỏ hàng:</h3>");
            response.getWriter().println("<pre>" + e.getMessage() + "</pre>");
            response.getWriter().println("<a href='bill.jsp'>Quay lại hóa đơn</a>");
        }
    }
}
