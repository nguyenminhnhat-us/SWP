package dal;

import controller.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Article;

public class ArticleDAO {
    
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
