package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/confirm-care-checkout")
public class ConfirmCareCheckoutServlet extends HttpServlet {
    private final CareCartDAO cartDAO = new CareCartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String cartIdParam = request.getParameter("cartId");
        String paymentMethod = request.getParameter("paymentMethod"); // vnpay or cod

        try {
            int cartId = Integer.parseInt(cartIdParam);

            if ("vnpay".equals(paymentMethod)) {
                // 🔁 Redirect sang VNPAY (giả lập)
                response.sendRedirect("vnpay-payment.jsp?cartId=" + cartId); // hoặc /vnpay-servlet
            } else if ("cod".equals(paymentMethod)) {
                // ✅ Cập nhật trạng thái đơn là "in_progress" hoặc "paid"
                cartDAO.updateCartStatus(cartId, "in_progress");

                // 👉 Thông báo & chuyển hướng
                request.setAttribute("message", "Thanh toán khi nhận hàng đã được xác nhận.");
                request.getRequestDispatcher("care-cart-success.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Phương thức thanh toán không hợp lệ.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi xử lý thanh toán: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
