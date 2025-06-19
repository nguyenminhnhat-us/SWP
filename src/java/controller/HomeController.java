package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dal.ArticleDAO;
import dal.CategoryDAO;
import dal.PlantDAO;
import model.Article;
import model.Category;
import model.Plant;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            PlantDAO plantDAO = new PlantDAO();
            ArticleDAO articleDAO = new ArticleDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            // Banner giữ nguyên, không cần xử lý

            // Top 5 sản phẩm bán chạy
            List<Plant> topSellingPlants = plantDAO.getTopSellingPlants(5);
            request.setAttribute("topSellingPlants", topSellingPlants);

            // 5 bài viết mới nhất
            List<Article> latestArticles = articleDAO.getLatestArticles(5);
            request.setAttribute("latestArticles", latestArticles);

            // Danh mục sản phẩm
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);

            // Sản phẩm phân trang
            int page = 1;
            int pageSize = 8;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            List<Plant> pagedPlants = plantDAO.getPagedPlants(page, pageSize);
            int totalProducts = plantDAO.getTotalPlantCount();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            request.setAttribute("plants", pagedPlants);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // Forward đến trang index.jsp
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
