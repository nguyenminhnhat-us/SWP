package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CareCart;
import model.CareService;
import model.User;

import java.io.IOException;
import java.util.List;
import java.util.Objects;

@WebServlet("/care-cart")
public class CareCartServlet extends HttpServlet {
    private final CareCartDAO cartDAO = new CareCartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("process-checkout".equals(action)) {
                handleProcessCheckout(request, response, user, session);
            } else if ("complete-checkout".equals(action)) {
                handleCompleteCheckout(request, response, user, session);
            } else {
                // Hiển thị danh sách đơn chăm sóc cây
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                List<CareCart> cartList = cartDAO.getAllCareCartsByUserId(user.getUserId());
                request.setAttribute("cartList", cartList);
                request.getRequestDispatcher("care-cart.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST giống GET
    }

    private void handleProcessCheckout(HttpServletRequest request, HttpServletResponse response,
                                       User user, HttpSession session)
            throws Exception {

        String cartIdParam = request.getParameter("cartId");
        if (user == null || cartIdParam == null || cartIdParam.isEmpty()) {
            request.setAttribute("error", "Thiếu thông tin người dùng hoặc mã đơn.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        int cartId = Integer.parseInt(cartIdParam);
        CareCart cart = cartDAO.getCareCartById(cartId);

        if (cart == null || !Objects.equals(cart.getUserId(), user.getUserId())) {
            request.setAttribute("error", "Bạn không có quyền truy cập đơn chăm sóc này.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        if (!"approved".equalsIgnoreCase(cart.getStatus())) {
            request.setAttribute("error", "Chỉ có thể thanh toán đơn đã được duyệt.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        List<CareService> services = cartDAO.getServicesByCartId(cartId);

        // Lưu vào session để hiển thị
        session.setAttribute("checkoutCart", cart);
        session.setAttribute("checkoutServices", services);
        session.setAttribute("checkoutAmount", cart.getTotalPrice().toString());
        session.setAttribute("checkoutCartId", String.valueOf(cart.getCartId()));

        request.getRequestDispatcher("checkout-care.jsp").forward(request, response);
    }

    private void handleCompleteCheckout(HttpServletRequest request, HttpServletResponse response,
                                        User user, HttpSession session)
            throws Exception {

        String method = request.getParameter("paymentMethod");
        String cartIdParam = request.getParameter("cartId");

        if (user == null || cartIdParam == null) {
            request.setAttribute("error", "Thiếu thông tin người dùng hoặc đơn hàng.");
            request.getRequestDispatcher("checkout-care.jsp").forward(request, response);
            return;
        }

        int cartId = Integer.parseInt(cartIdParam);
        CareCart cart = cartDAO.getCareCartById(cartId);

        if (!Objects.equals(cart.getUserId(), user.getUserId())) {
            request.setAttribute("error", "Bạn không có quyền với đơn này.");
            request.getRequestDispatcher("checkout-care.jsp").forward(request, response);
            return;
        }

        if ("cod".equalsIgnoreCase(method)) {
            cartDAO.updateCartStatus(cartId, "in_progress");

            // ✅ Gửi thông báo thành công qua session
            session.setAttribute("successMessage", "✅ Thanh toán thành công! Đơn của bạn đang được xử lý.");

            // ✅ Quay lại trang giỏ dịch vụ
            response.sendRedirect(request.getContextPath() + "/care-cart");
            return;

        } else if ("vnpay".equalsIgnoreCase(method)) {
            String amount = cart.getTotalPrice().toString();
            response.sendRedirect(request.getContextPath() + "/ajaxServlet?amount=" + amount + "&target=care&cartId=" + cartId);
        } else {
            request.setAttribute("error", "Phương thức thanh toán không hợp lệ.");
            request.getRequestDispatcher("checkout-care.jsp").forward(request, response);
        }
    }
}
