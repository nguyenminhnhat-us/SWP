package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Plant;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dal.PlantDAO;

@WebServlet("/plants")
public class PlantServlet extends HttpServlet {
    private PlantDAO plantDAO = new PlantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("PlantServlet được gọi lúc " + new java.util.Date());
        try {
            List<Plant> plants = plantDAO.getAllPlants();
            System.out.println("Số lượng cây từ PlantDAO: " + (plants != null ? plants.size() : "null") + " lúc " + new java.util.Date());
            if (plants == null || plants.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy danh sách sản phẩm. Kiểm tra bảng Plants. Số lượng: " + (plants != null ? plants.size() : "null"));
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            request.setAttribute("plants", plants);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println("Lỗi trong PlantServlet lúc " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách sản phẩm: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}