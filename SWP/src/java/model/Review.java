package model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int userId;
    private int plantId;
    private int orderId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public Review() {}

    public Review(int reviewId, int userId, int plantId, int orderId, int rating, String comment, Timestamp createdAt, String userName) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.plantId = plantId;
        this.orderId = orderId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getPlantId() { return plantId; }
    public void setPlantId(int plantId) { this.plantId = plantId; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    

    @Override
    public String toString() {
        return "Review{" +
                "reviewId=" + reviewId +
                ", userId=" + userId +
                ", plantId=" + plantId +
                ", orderId=" + orderId +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", createdAt=" + createdAt +
                +
                '}';
    }
}
