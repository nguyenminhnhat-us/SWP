package controller.dashboard;

import dal.CareServiceDAO;
import model.CareService;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/dashboard/care-services")
public class CareServiceManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            CareServiceDAO dao = new CareServiceDAO();
            List<CareService> services = dao.getAllServices();
            request.setAttribute("services", services);
            request.getRequestDispatcher("/dashboard/admin/manage-care-services.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            throw new ServletException(e);
        }
    }
}
