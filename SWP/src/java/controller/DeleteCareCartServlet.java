
import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/delete-care-cart")
public class DeleteCareCartServlet extends HttpServlet {
    private final CareCartDAO cartDAO = new CareCartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            cartDAO.deleteCartById(cartId);
            response.sendRedirect("care-cart"); // Reload lại sau khi xóa
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xóa đơn: " + e.getMessage());
            request.getRequestDispatcher("care-cart.jsp").forward(request, response);
        }
    }
}
