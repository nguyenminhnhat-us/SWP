package controller;

import model.PlantDAO;
import model.Plant;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/plantList")
public class PlantListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryParam = request.getParameter("category");
        PlantDAO plantDAO = new PlantDAO();
        List<Plant> plants;

        if (categoryParam != null) {
            try {
                int categoryId = Integer.parseInt(categoryParam);
                plants = plantDAO.getPlantsByCategory(categoryId);
            } catch (NumberFormatException e) {
                // Nếu category không hợp lệ, fallback lấy toàn bộ
                plants = plantDAO.getAllPlants();
            }
        } else {
            plants = plantDAO.getAllPlants();
        }

        request.setAttribute("plants", plants);
        request.getRequestDispatcher("/plantList.jsp").forward(request, response);
    }
}
