package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/approve-care-cart")
public class ApproveCareCartServlet extends HttpServlet {
    private final CareCartDAO dao = new CareCartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String cartIdStr = request.getParameter("cartId");
        String status = request.getParameter("status");

        try {
            int cartId = Integer.parseInt(cartIdStr);
            if (status == null || status.isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu trạng thái.");
                return;
            }

            boolean success = dao.updateCartStatus(cartId, status);
            if (success) {
                // ✅ Sau khi cập nhật thành công, quay lại danh sách
                response.sendRedirect("care-orders"); // ➜ gọi ExpertCareOrdersServlet
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể cập nhật trạng thái.");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý trạng thái.");
        }
    }
}
