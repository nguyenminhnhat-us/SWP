package controller;

import model.Article;
import dal.ArticleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/articleList")
public class ArticleListServlet extends HttpServlet {

    private ArticleDAO articleDAO = new ArticleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Article> articles = articleDAO.getAllArticles();
        if (articles == null || articles.isEmpty()) {
            request.setAttribute("error", "Không có bài viết nào để hiển thị.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        request.setAttribute("articles", articles);
        request.getRequestDispatcher("/articleList.jsp").forward(request, response);
    }
}