
import dal.CareServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.CareService;

@WebServlet("/dashboard/care-services/edit")
public class EditCareServiceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        CareServiceDAO dao = new CareServiceDAO();
        try {
            CareService service = dao.getServiceById(id);
            request.setAttribute("service", service);
            request.getRequestDispatcher("/dashboard/admin/edit-care-service.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
