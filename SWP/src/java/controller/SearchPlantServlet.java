package controller;

import controller.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Plant;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/searchPlant")
public class SearchPlantServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Plant> plantList = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM Plants WHERE LOWER(name) LIKE ? AND stock_quantity > 0";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + keyword.toLowerCase() + "%");

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Plant plant = new Plant(
                    rs.getInt("plant_id"),
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getDouble("price"),
                    rs.getInt("stock_quantity"),
                    rs.getString("image_url")
                );
                plantList.add(plant);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("plants", plantList);
        request.getRequestDispatcher("/search_results.jsp").forward(request, response);
    }
}
