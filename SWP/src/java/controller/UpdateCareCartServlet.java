package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/update-care-cart")
public class UpdateCareCartServlet extends HttpServlet {
    private final CareCartDAO cartDAO = new CareCartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy và kiểm tra cartId
            String cartIdRaw = request.getParameter("cartId");
            if (cartIdRaw == null || cartIdRaw.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu thông tin đơn cần chỉnh sửa (cartId bị rỗng).");
                request.getRequestDispatcher("care-cart.jsp").forward(request, response);
                return;
            }

            int cartId = Integer.parseInt(cartIdRaw);

            // Các tham số khác
            String plantName = request.getParameter("plantName");
            String dropOffDate = request.getParameter("dropOffDate");
            String appointmentTime = request.getParameter("appointmentTime");
            String locationType = request.getParameter("locationType");
            String homeAddress = request.getParameter("homeAddress");
            String notes = request.getParameter("notes");
            int hoursPerDay = Integer.parseInt(request.getParameter("hoursPerDay"));

            // Dịch vụ đã chọn
            String[] serviceIdStrings = request.getParameterValues("serviceIds");
            List<Integer> serviceIds = new ArrayList<>();
            if (serviceIdStrings != null) {
                for (String idStr : serviceIdStrings) {
                    serviceIds.add(Integer.parseInt(idStr));
                }
            }

            // Cập nhật database
            cartDAO.updateCareCart(cartId, plantName, dropOffDate, appointmentTime,
                    locationType, homeAddress, notes, hoursPerDay, serviceIds);

            response.sendRedirect("care-cart.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cập nhật đơn: " + e.getMessage());
            request.getRequestDispatcher("edit-care-cart.jsp").forward(request, response);
        }
    }
}
