package controller.dashboard;

import dal.CareServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/dashboard/care-services/delete")
public class DeleteCareServiceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CareServiceDAO dao = new CareServiceDAO();
            dao.deleteService(id);

            response.sendRedirect(request.getContextPath() + "/dashboard/care-services");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Xóa thất bại.");
        }
    }
}
