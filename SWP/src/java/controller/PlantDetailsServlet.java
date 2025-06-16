/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;



import model.PlantDAO;
import model.Plant;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/plantDetailsServlet")
public class PlantDetailsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int plantId = Integer.parseInt(request.getParameter("plantId"));
        PlantDAO plantDAO = new PlantDAO();
        Plant plant = plantDAO.getPlantById(plantId);
        request.setAttribute("plant", plant);
        request.getRequestDispatcher("/plantDetails.jsp").forward(request, response);
    }
}