package controller;

import dal.CartDAO;
import model.CartItem;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int userId = request.getSession().getAttribute("user") != null
                ? ((User) request.getSession().getAttribute("user")).getUserId()
                : 0; // Giả sử User là lớp mô hình của bạn
        if (userId == 0) {
            request.setAttribute("error", "Vui lòng đăng nhập để sử dụng giỏ hàng.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            if ("add".equals(action)) {
                int plantId = Integer.parseInt(request.getParameter("plantId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartDAO.addToCart(userId, plantId, quantity);
            } else if ("update".equals(action)) {
                int plantId = Integer.parseInt(request.getParameter("plantId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartDAO.updateCartItem(userId, plantId, quantity);
            } else if ("delete".equals(action)) {
                int plantId = Integer.parseInt(request.getParameter("plantId"));
                cartDAO.removeCartItem(userId, plantId);
            } else if ("clear".equals(action)) {
                cartDAO.clearCart(userId);
            }

            // Cập nhật danh sách cartItems trong session
            List<CartItem> cartItems = cartDAO.getCartItems(userId);
            request.getSession().setAttribute("cartItems", cartItems);

            // Chuyển hướng về trang giỏ hàng
            response.sendRedirect(request.getContextPath() + "/cart.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("error", "Lỗi khi xử lý giỏ hàng: " + e.getMessage());
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = request.getSession().getAttribute("user") != null
                ? ((User) request.getSession().getAttribute("user")).getUserId()
                : 0;
        try {
            List<CartItem> cartItems = cartDAO.getCartItems(userId);
            request.getSession().setAttribute("cartItems", cartItems);
            double total = cartItems.stream()
                    .mapToDouble(item -> item.getPlant().getPrice() * item.getQuantity())
                    .sum();
            request.setAttribute("total", total);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            request.setAttribute("error", "Lỗi khi tải giỏ hàng: " + e.getMessage());
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }
}
