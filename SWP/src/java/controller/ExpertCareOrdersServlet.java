package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.CareCart;
import model.User;

@WebServlet("/care-orders")
public class ExpertCareOrdersServlet extends HttpServlet {
    private final CareCartDAO careCartDAO = new CareCartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("📥 [ExpertCareOrdersServlet] Bắt đầu xử lý");

        HttpSession session = request.getSession();
        User expert = (User) session.getAttribute("user");

        if (expert == null) {
            System.out.println("❌ Chưa đăng nhập");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (!"expert".equalsIgnoreCase(expert.getRole())) {
            System.out.println("❌ Không phải vai trò expert: " + expert.getRole());
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int expertId = expert.getUserId();
            System.out.println("🔍 Đang tìm đơn theo expert_id = " + expertId);

            List<CareCart> assignedCarts = careCartDAO.getCartsByExpertId(expertId);

            System.out.println("✅ Số đơn tìm được: " + (assignedCarts != null ? assignedCarts.size() : 0));
            request.setAttribute("assignedCarts", assignedCarts);

            System.out.println("➡️ Forward đến expert-care-cart.jsp");
            request.getRequestDispatcher("expert-care-cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải danh sách đơn dịch vụ.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
