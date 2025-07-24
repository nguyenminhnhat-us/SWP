package controller;

import dal.CareServiceDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/book-care")
public class BookCareServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            // Lấy tham số và kiểm tra null
            String plantName = request.getParameter("plantName");
            String[] serviceIdsRaw = request.getParameterValues("serviceIds");
            String expertIdRaw = request.getParameter("expertId");
            String careDatesStr = request.getParameter("careDates");
            String locationType = request.getParameter("locationType");
            String homeAddress = request.getParameter("homeAddress");
            String appointmentTime = request.getParameter("appointmentTime");
            String notes = request.getParameter("notes");
            String hoursRaw = request.getParameter("hoursPerDay");

            // Debug log
            System.out.println("DEBUG expertId: " + expertIdRaw);
            System.out.println("DEBUG hoursPerDay: " + hoursRaw);
            System.out.println("DEBUG careDates: " + careDatesStr);
            System.out.println("DEBUG serviceIds: " + Arrays.toString(serviceIdsRaw));

            // Kiểm tra bắt buộc
            if (expertIdRaw == null || expertIdRaw.isEmpty()) {
                throw new IllegalArgumentException("Thiếu expertId");
            }
            if (careDatesStr == null || careDatesStr.isEmpty()) {
                throw new IllegalArgumentException("Thiếu ngày chăm sóc");
            }
            if (hoursRaw == null || hoursRaw.isEmpty()) {
                throw new IllegalArgumentException("Thiếu giờ chăm sóc mỗi ngày");
            }

            int expertId = Integer.parseInt(expertIdRaw);
            int hoursPerDay = Integer.parseInt(hoursRaw);
            String[] careDatesRaw = careDatesStr.split(",");

            // Chuyển serviceIds thành danh sách số nguyên
            List<Integer> serviceIds = new ArrayList<>();
            if (serviceIdsRaw != null) {
                for (String sid : serviceIdsRaw) {
                    serviceIds.add(Integer.parseInt(sid));
                }
            }

            CareServiceDAO serviceDAO = new CareServiceDAO();
            UserDAO userDAO = new UserDAO();

            // Tính tổng giá dịch vụ
            BigDecimal totalServiceCost = BigDecimal.ZERO;
            List<CareService> selectedServices = new ArrayList<>();
            for (int sid : serviceIds) {
                CareService service = serviceDAO.getServiceById(sid);
                selectedServices.add(service);
                totalServiceCost = totalServiceCost.add(BigDecimal.valueOf(service.getPrice()));
            }

            // Lấy giá của chuyên gia
            BigDecimal expertCostPerDay = userDAO.getExpertDailyPrice(expertId);
            int totalDays = careDatesRaw.length;
            BigDecimal expertTotalCost = expertCostPerDay.multiply(BigDecimal.valueOf(totalDays));

            BigDecimal totalCost = totalServiceCost.add(expertTotalCost);

            // Gửi dữ liệu qua JSP
            request.setAttribute("plantName", plantName);
            request.setAttribute("careDates", Arrays.asList(careDatesRaw));
            request.setAttribute("selectedServices", selectedServices);
            request.setAttribute("expert", userDAO.getUserById(expertId));
            request.setAttribute("totalServiceCost", totalServiceCost);
            request.setAttribute("expertCost", expertTotalCost);
            request.setAttribute("totalCost", totalCost);
            request.setAttribute("locationType", locationType);
            request.setAttribute("homeAddress", homeAddress);
            request.setAttribute("appointmentTime", appointmentTime);
            request.setAttribute("notes", notes);
            request.setAttribute("hoursPerDay", hoursPerDay);

            request.getRequestDispatcher("bill.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý đơn đặt lịch: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
