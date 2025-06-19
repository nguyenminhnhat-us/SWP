package controller;

import model.Plant;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import dal.PlantDAO;

@WebServlet("/plantList")
public class PlantListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categoryParam = request.getParameter("category");
        PlantDAO plantDAO = new PlantDAO();
        List<Plant> plants = null;

        if (categoryParam != null) {
            try {
                int categoryId = Integer.parseInt(categoryParam);
                plants = plantDAO.getPlantsByCategory(categoryId);
            } catch (NumberFormatException e) {
                try {
                    // Nếu category không hợp lệ, fallback lấy toàn bộ
                    plants = plantDAO.getAllPlants();
                } catch (SQLException ex) {
                    Logger.getLogger(PlantListServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (ClassNotFoundException ex) {
                    Logger.getLogger(PlantListServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else {
            try {
                plants = plantDAO.getAllPlants();
            } catch (SQLException ex) {
                Logger.getLogger(PlantListServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(PlantListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        request.setAttribute("plants", plants);
        request.getRequestDispatcher("/plantList.jsp").forward(request, response);
    }
}
