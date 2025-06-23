package controller;

import model.CartItem;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dal.CartDAO;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải giỏ hàng.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if ("add".equals(action)) {
                int plantId = Integer.parseInt(request.getParameter("plantId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartDAO.addToCart(user.getUserId(), plantId, quantity);
            } else if ("update".equals(action)) {
                int plantId = Integer.parseInt(request.getParameter("plantId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartDAO.updateCartItem(user.getUserId(), plantId, quantity);
            } else if ("delete".equals(action)) {
                int plantId = Integer.parseInt(request.getParameter("plantId"));
                cartDAO.removeCartItem(user.getUserId(), plantId);
            } else if ("clear".equals(action)) {
                cartDAO.clearCart(user.getUserId());
            }
            response.sendRedirect("cart");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý giỏ hàng.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}