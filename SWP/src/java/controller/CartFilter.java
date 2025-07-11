package controller;

import dal.CartDAO;
import model.CartItem;
import model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebFilter("/*")
public class CartFilter implements Filter {
    private CartDAO cartDAO = new CartDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession();
        int userId = session.getAttribute("user") != null 
            ? ((User) session.getAttribute("user")).getUserId() 
            : 0;

        if (userId != 0) {
            try {
                List<CartItem> cartItems = cartDAO.getCartItems(userId);
                session.setAttribute("cartItems", cartItems);
            } catch (SQLException | ClassNotFoundException e) {
                // Ghi log lỗi nếu cần
                System.err.println("Lỗi khi tải giỏ hàng trong filter: " + e.getMessage());
            }
        } else {
            // Nếu không có người dùng đăng nhập, xóa cartItems khỏi session
            session.removeAttribute("cartItems");
        }

        // Tiếp tục xử lý yêu cầu
        chain.doFilter(request, response);
    }
}