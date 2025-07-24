package controller;

import dal.ArticleDAO;
import model.Article;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet("/post-article")
public class PostArticleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy dữ liệu từ form
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String category = request.getParameter("category");

            // Lấy authorId từ session (giả sử đã login)
            HttpSession session = request.getSession();
            Integer authorId = (Integer) session.getAttribute("userId"); // cần đảm bảo đã đăng nhập

            // Tạo đối tượng bài viết
            Article article = new Article();
            article.setTitle(title);
            article.setContent(content);
            article.setCategory(category);
            article.setAuthorId(authorId);
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            article.setCreatedAt(now);
            article.setUpdatedAt(now);

            // Lưu bài viết vào database
            ArticleDAO dao = new ArticleDAO();
            dao.insertArticle(article);

            // Hiển thị thông báo thành công
            request.setAttribute("message", "Bài viết đã được đăng thành công!");
            request.getRequestDispatcher("write-article.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Hiển thị thông báo lỗi
            request.setAttribute("error", "Đã xảy ra lỗi khi đăng bài.");
            request.getRequestDispatcher("write-article.jsp").forward(request, response);
        }
    }

    // Nếu người dùng vào bằng GET, hiển thị form viết bài
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("write-article.jsp").forward(request, response);
    }
}
