package dal;

import controller.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
<<<<<<< HEAD
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
=======
import java.util.ArrayList;
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
import java.util.List;
import model.Article;

public class ArticleDAO {
<<<<<<< HEAD

    public List<Article> getAllArticles() throws SQLException, ClassNotFoundException {
        List<Article> articles = new ArrayList<>();
        String sql = "SELECT article_id, author_id, title, content, category, created_at, updated_at FROM Articles";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Chuyển đổi LocalDateTime sang java.util.Date
                LocalDateTime createdAt = rs.getObject("created_at", LocalDateTime.class);
                LocalDateTime updatedAt = rs.getObject("updated_at", LocalDateTime.class);
                Date createdAtDate = Date.from(createdAt.atZone(java.time.ZoneId.systemDefault()).toInstant());
                Date updatedAtDate = Date.from(updatedAt.atZone(java.time.ZoneId.systemDefault()).toInstant());

                articles.add(new Article(
                        rs.getInt("article_id"),
                        rs.getInt("author_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("category"),
                        createdAtDate, // Sử dụng java.util.Date
                        updatedAtDate // Sử dụng java.util.Date
                ));
            }
        }
        return articles;
    }
=======
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
    
    public List<Article> getLatestArticles(int limit) throws SQLException, ClassNotFoundException {
        List<Article> list = new ArrayList<>();
        String sql = "SELECT a.article_id, a.author_id, a.title, a.content, a.category, a.created_at, a.updated_at " +
                     "FROM Articles a LEFT JOIN Users u ON a.author_id = u.user_id " +
                     "ORDER BY a.created_at DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int articleId = rs.getInt("article_id");
                Integer authorId = rs.getObject("author_id") != null ? rs.getInt("author_id") : null;
                String title = rs.getString("title");
                String content = rs.getString("content");
                String category = rs.getString("category");
                java.sql.Timestamp createdAt = rs.getTimestamp("created_at");
                java.sql.Timestamp updatedAt = rs.getTimestamp("updated_at");
                Article article = new Article(articleId, authorId, title, content, category, createdAt, updatedAt);
                list.add(article);
            }
        }
        return list;
    }
}
