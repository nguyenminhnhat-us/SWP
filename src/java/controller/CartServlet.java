package controller;

import config.VNPAYConfig;
import dal.CartDAO;
import dal.OrderDAO;
import model.CartItem;
import model.Order;
import model.OrderDetail;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Enumeration;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("complete-checkout".equals(action)) {
            completeCheckout(request, response);
            return;
        } else if ("process-checkout".equals(action)) {
            processCheckout(request, response);
            return;
        }

        displayCart(request, response, user);
    }
    
    private void processCheckout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
            if (cartItems.isEmpty()) {
                session.setAttribute("message", "Your cart is empty. Cannot proceed to checkout.");
                session.setAttribute("messageType", "warning");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            // Store the cart items in the session for checkout.jsp to access
            session.setAttribute("checkoutCartItems", cartItems);
            
            // Calculate total amount
            BigDecimal total = cartItems.stream()
                                        .map(item -> BigDecimal.valueOf(item.getPlant().getPrice()).multiply(new BigDecimal(item.getQuantity())))
                                        .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Set attributes for checkout.jsp
            request.setAttribute("user", user); // User info for display on bill
            request.setAttribute("total", total); // Total amount for display on bill

            // Forward to checkout.jsp to display bill and confirm payment
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("message", "An error occurred while preparing for checkout.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
    
    private void displayCart(HttpServletRequest request, HttpServletResponse response, User user) throws ServletException, IOException {
        try {
            List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
            BigDecimal total = cartItems.stream()
                                        .map(item -> BigDecimal.valueOf(item.getPlant().getPrice()).multiply(new BigDecimal(item.getQuantity())))
                                        .reduce(BigDecimal.ZERO, BigDecimal::add);
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("total", total);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải giỏ hàng.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private void completeCheckout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get checkout information from session
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("checkoutCartItems");
        
        if (cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("message", "Your checkout session has expired. Please try again.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Get VNPAY payment response parameters
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_Amount = request.getParameter("vnp_Amount");
        
        // Verify the transaction was started by this session
        String sessionTxnRef = (String) session.getAttribute("vnp_TxnRef");
        String sessionAmount = (String) session.getAttribute("vnp_Amount");
        
        // Only proceed if we have a response from VNPAY
        if (vnp_ResponseCode != null && vnp_TransactionStatus != null) {
            if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                // Verify transaction matches what we sent
                if (sessionTxnRef != null && sessionAmount != null) {
                    if (!sessionTxnRef.equals(vnp_TxnRef) || !sessionAmount.equals(vnp_Amount)) {
                        session.setAttribute("message", "Payment verification failed. Transaction details do not match.");
                        session.setAttribute("messageType", "error");
                        response.sendRedirect(request.getContextPath() + "/cart");
                        return;
                    }
                }
                
                // Payment successful - process the order
                processSuccessfulOrder(request, response, user, cartItems, "VNPAY");
            } else {
                // Payment failed
                session.setAttribute("message", "Payment was not successful. Response code: " + vnp_ResponseCode);
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } else {
            // This case might be for testing or alternative payment methods.
            // As per security best practices, it's safer to assume an order is only valid
            // if a positive confirmation from the payment gateway is received.
            // For now, we can treat it as a failed/incomplete payment.
            session.setAttribute("message", "Payment could not be confirmed.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void processSuccessfulOrder(HttpServletRequest request, HttpServletResponse response, User user, List<CartItem> cartItems, String paymentMethod) throws ServletException, IOException {
        HttpSession session = request.getSession();
        try {
            if (cartItems.isEmpty()) {
                 request.setAttribute("message", "Your cart is empty. Cannot process order.");
                 request.setAttribute("messageType", "warning");
                 displayCart(request, response, user);
                 return;
            }
            
            BigDecimal totalAmount = cartItems.stream()
                .map(item -> BigDecimal.valueOf(item.getPlant().getPrice()).multiply(new BigDecimal(item.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

            Order order = new Order(user.getUserId(), totalAmount, "pending", user.getAddress(), paymentMethod);
            int orderId = orderDAO.createOrder(order);

            List<OrderDetail> orderDetails = new ArrayList<>();
            for (CartItem item : cartItems) {
                orderDetails.add(new OrderDetail(orderId, item.getPlantId(), item.getQuantity(), BigDecimal.valueOf(item.getPlant().getPrice())));
            }
            orderDAO.createOrderDetails(orderId, orderDetails);

            cartDAO.clearCart(user.getUserId());
            
            // Clear checkout session attributes
            session.removeAttribute("vnp_TxnRef");
            session.removeAttribute("vnp_Amount");
            session.removeAttribute("checkoutCartItems");

            String successMessage = "VNPAY".equals(paymentMethod) ? 
                "Payment successful! Your order has been placed." : 
                "Order placed successfully! You will pay when you receive the goods.";
            request.setAttribute("message", successMessage);
            request.setAttribute("messageType", "success");
            
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred while processing your order: " + e.getMessage());
            request.setAttribute("messageType", "error");
        }
        
        displayCart(request, response, user);
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
            } else if ("complete-order".equals(action)) {
                handleCompleteOrder(request, response);
                return;
            }
            response.sendRedirect("cart");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý giỏ hàng.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    private void handleCompleteOrder(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String paymentMethod = request.getParameter("payment_method");
        
        // Get cart items from session (should be set during process-checkout)
        @SuppressWarnings("unchecked")
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("checkoutCartItems");
        
        if (cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("message", "Your checkout session has expired. Please try again.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        if ("COD".equals(paymentMethod)) {
            // Process COD order directly
            processSuccessfulOrder(request, response, user, cartItems, "COD");
        } else {
            // For VNPAY, this shouldn't happen as it should go through ajaxServlet
            session.setAttribute("message", "Invalid payment method.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
