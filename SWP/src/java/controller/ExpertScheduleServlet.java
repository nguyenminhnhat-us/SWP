package controller;

import dal.CareCartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CareCart;
import model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/expert-schedule")
public class ExpertScheduleServlet extends HttpServlet {
    private final CareCartDAO dao = new CareCartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User expert = (User) session.getAttribute("user");

        if (expert == null || !"expert".equals(expert.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            List<CareCart> schedule = dao.getAssignedScheduleByExpert(expert.getUserId());
            request.setAttribute("schedule", schedule);
            request.getRequestDispatcher("care-schedule.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải lịch.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
