package controller;

import dal.OrderDAO;
import dal.ReviewDAO;
import model.Review;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int plantId = Integer.parseInt(request.getParameter("plantId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        try {
            // 1. Check if user has purchased the plant
            if (!orderDAO.hasUserPurchasedPlant(user.getUserId(), plantId)) {
                session.setAttribute("message", "Bạn chỉ có thể đánh giá sản phẩm đã mua.");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + plantId);
                return;
            }

            // 2. Get the orderId for the review
            int orderId = orderDAO.getOrderIdForUserAndPlant(user.getUserId(), plantId);
            if (orderId == -1) {
                // This case should ideally not happen if hasUserPurchasedPlant returns true
                session.setAttribute("message", "Không tìm thấy đơn hàng hợp lệ để đánh giá.");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + plantId);
                return;
            }

            // 3. Create Review object
            Review review = new Review();
            review.setUserId(user.getUserId());
            review.setPlantId(plantId);
            review.setOrderId(orderId);
            review.setRating(rating);
            review.setComment(comment);

            // 4. Add review to database
            reviewDAO.addReview(review);

            session.setAttribute("message", "Đánh giá của bạn đã được gửi thành công!");
            session.setAttribute("messageType", "success");
            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + plantId);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            session.setAttribute("message", "Đã xảy ra lỗi khi gửi đánh giá: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/plantDetails?plantId=" + plantId);
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Dữ liệu đánh giá không hợp lệ.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/plantDetails?plantId=" + plantId);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported for this servlet.");
    }
}
