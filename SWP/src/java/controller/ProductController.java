package controller;

import dal.ArticleDAO;
import dal.PlantDAO;
import dal.CategoryDAO;
import dal.ReviewDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Article;
import model.Plant;
import model.Review;

@WebServlet(name = "ProductController", urlPatterns = {"/product-detail"})
public class ProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int plantId = Integer.parseInt(request.getParameter("id"));
            PlantDAO plantDAO = new PlantDAO();
            ArticleDAO articleDAO = new ArticleDAO();
            ReviewDAO reviewDAO = new ReviewDAO();
            UserDAO userDAO = new UserDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            // Lấy thông tin sản phẩm
            Plant product = plantDAO.getPlantById(plantId);
            // Lấy tên category
            String categoryName = "";
            if (product != null) {
                categoryName = categoryDAO.getCategoryNameById(product.getCategoryId());
            }
            // Đóng gói product và categoryName vào map
            Map<String, Object> productMap = new HashMap<>();
            productMap.put("product", product);
            productMap.put("categoryName", categoryName);
            request.setAttribute("productMap", productMap);

            // Lấy feedback cho sản phẩm
            List<Review> feedbacks = reviewDAO.getReviewsByPlantId(plantId);
            List<Map<String, Object>> feedbackList = new ArrayList<>();
            for (Review r : feedbacks) {
                Map<String, Object> map = new HashMap<>();
                map.put("review", r);
                // Lấy tên user
                String userName = userDAO.getUserNameById(r.getUserId());
                map.put("userName", userName);
                // Lấy tên plant nếu cần
                String plantName = plantDAO.getPlantNameById(r.getPlantId());
                map.put("plantName", plantName);
                feedbackList.add(map);
            }
            request.setAttribute("feedbackList", feedbackList);

            // Lấy sản phẩm liên quan (cùng category, trừ chính nó)
            List<Plant> relatedPlants = plantDAO.getRelatedPlants(product.getCategoryId(), plantId, 10);
            request.setAttribute("relatedPlants", relatedPlants);

            // Bài viết mới nhất
            List<Article> latestArticles = articleDAO.getLatestArticles(5);
            request.setAttribute("latestArticles", latestArticles);

            // Top sản phẩm bán chạy
            List<Plant> topSellingPlants = plantDAO.getTopSellingPlants(5);
            request.setAttribute("topSellingPlants", topSellingPlants);

            request.getRequestDispatcher("/productDetail.jsp").forward(request, response);
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
