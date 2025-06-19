package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ArticleDAO {
    
    public List<Article> getLatestArticles(int limit) throws SQLException {
        List<Article> list = new ArrayList<>();
        String sql = "SELECT a.article_id, a.title, a.content, a.category, a.created_at, a.updated_at, u.full_name AS author_name " +
                     "FROM Articles a LEFT JOIN Users u ON a.author_id = u.user_id " +
                     "ORDER BY a.created_at DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tạo Article từ rs
                // ...
                list.add(article);
            }
        }
        return list;
    }
}
