package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "VNPAYReturnServlet", urlPatterns = {"/vnpay-return"})
public class VNPAYReturnServlet extends HttpServlet {

    private final CareCartDAO cartDAO = new CareCartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String responseCode = request.getParameter("vnp_ResponseCode");
        String target = request.getParameter("target");
        String cartIdParam = request.getParameter("cartId");

        // ❌ Thanh toán thất bại
        if (responseCode == null || !"00".equals(responseCode)) {
            session.setAttribute("errorMessage", "❌ Thanh toán thất bại hoặc bị hủy.");
            response.sendRedirect(request.getContextPath() + "/care-cart");
            return;
        }

        // ❌ Thiếu thông tin bắt buộc
        if (target == null || !"care".equalsIgnoreCase(target) || cartIdParam == null) {
            session.setAttribute("errorMessage", "❌ Thiếu thông tin đơn thanh toán.");
            response.sendRedirect(request.getContextPath() + "/care-cart");
            return;
        }

        try {
            int cartId = Integer.parseInt(cartIdParam);
            boolean updated = cartDAO.updateCartStatus(cartId, "in_progress");

            if (updated) {
                // ✅ Xóa các session checkout
                session.removeAttribute("checkoutCart");
                session.removeAttribute("checkoutServices");
                session.removeAttribute("checkoutAmount");
                session.removeAttribute("checkoutCartId");

                session.setAttribute("successMessage", "✅ Thanh toán VNPAY thành công. Đơn chăm sóc cây #" + cartId + " đã được xác nhận!");
            } else {
                session.setAttribute("errorMessage", "⚠️ Không thể cập nhật trạng thái đơn. Vui lòng liên hệ hỗ trợ.");
            }

            response.sendRedirect(request.getContextPath() + "/care-cart");

        } catch (NumberFormatException | SQLException | ClassNotFoundException e) {
            Logger.getLogger(VNPAYReturnServlet.class.getName()).log(Level.SEVERE, null, e);
            session.setAttribute("errorMessage", "❌ Lỗi xử lý đơn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/care-cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
