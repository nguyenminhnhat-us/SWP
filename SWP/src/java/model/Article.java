package model;

<<<<<<< HEAD
import java.util.Date;

public class Article {

    private int articleId;
    private int authorId;
    private String title;
    private String content;
    private String category;
    private Date createdAt; // Thay LocalDateTime bằng Date
    private Date updatedAt; // Thay LocalDateTime bằng Date

    public Article() {
    }

    public Article(int articleId, int authorId, String title, String content, String category, Date createdAt, Date updatedAt) {
=======
import java.sql.Timestamp;

public class Article {
    private int articleId;
    private Integer authorId; // Có thể null
    private String title;
    private String content;
    private String category;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Article() {}

    public Article(int articleId, Integer authorId, String title, String content, String category, Timestamp createdAt, Timestamp updatedAt) {
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
        this.articleId = articleId;
        this.authorId = authorId;
        this.title = title;
        this.content = content;
        this.category = category;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

<<<<<<< HEAD
    // Getters và Setters
    public int getArticleId() {
        return articleId;
    }

    public void setArticleId(int articleId) {
        this.articleId = articleId;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
=======
    public int getArticleId() {
        return articleId;
    }
    public void setArticleId(int articleId) {
        this.articleId = articleId;
    }
    public Integer getAuthorId() {
        return authorId;
    }
    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public String getCategory() {
        return category;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
   

    @Override
    public String toString() {
        return "Article{" +
                "articleId=" + articleId +
                ", authorId=" + authorId +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", category='" + category + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                 
                '}';
    }
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
}
