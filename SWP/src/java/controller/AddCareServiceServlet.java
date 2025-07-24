package controller.dashboard;

import dal.CareServiceDAO;
import model.CareService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/dashboard/care-services/add")
public class AddCareServiceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int durationDays = Integer.parseInt(request.getParameter("durationDays"));

            CareService newService = new CareService();
            newService.setName(name);
            newService.setDescription(description);
            newService.setPrice(price);
            newService.setDurationDays(durationDays);

            CareServiceDAO dao = new CareServiceDAO();
            dao.insertService(newService);

            response.sendRedirect(request.getContextPath() + "/dashboard/care-services");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Thêm dịch vụ thất bại.");
        }
    }
}
