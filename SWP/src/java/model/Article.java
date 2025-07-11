package model;

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
        this.articleId = articleId;
        this.authorId = authorId;
        this.title = title;
        this.content = content;
        this.category = category;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

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
}
