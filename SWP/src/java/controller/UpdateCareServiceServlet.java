package controller.dashboard;

import dal.CareServiceDAO;
import model.CareService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/dashboard/care-services/update")
public class UpdateCareServiceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int durationDays = Integer.parseInt(request.getParameter("durationDays"));

            CareService service = new CareService();
            service.setServiceId(serviceId);
            service.setName(name);
            service.setDescription(description);
            service.setPrice(price);
            service.setDurationDays(durationDays);

            CareServiceDAO dao = new CareServiceDAO();
            dao.updateService(service);

            response.sendRedirect(request.getContextPath() + "/dashboard/care-services");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cập nhật dịch vụ thất bại.");
        }
    }
}
