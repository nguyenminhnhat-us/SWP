<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Plant" %>
<%@ page import="model.User" %>
<%@ page import="dal.ReviewDAO" %>
<%@ page import="dal.OrderDAO" %>
<%@ page import="model.Review" %>
<%@ page import="java.util.List" %>
<%
    Plant plant = (Plant) request.getAttribute("plant");
    User currentUser = (User) session.getAttribute("user");
    
    ReviewDAO reviewDAO = new ReviewDAO();
    OrderDAO orderDAO = new OrderDAO();
    
    List<Review> reviews = null;
    boolean hasPurchased = false;
    
    try {
        if (plant != null) {
            reviews = reviewDAO.getReviewsByPlantId(plant.getPlantId());
        }
        if (currentUser != null && plant != null) {
            hasPurchased = orderDAO.hasUserPurchasedPlant(currentUser.getUserId(), plant.getPlantId());
        }
    } catch (Exception e) {
        e.printStackTrace();
        // Handle error, maybe set an error message in request attribute
    }
    
    // Set attributes for JSTL access
    request.setAttribute("plant", plant);
    request.setAttribute("reviews", reviews);
    request.setAttribute("hasPurchased", hasPurchased);
    request.setAttribute("currentUser", currentUser);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${plant.name} | Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        .product-detail-container {
            margin: 50px auto;
            max-width: 1000px;
            display: flex;
            gap: 30px;
        }
        .product-detail-container img {
            max-width: 450px;
            border-radius: 10px;
        }
        .product-info h2 {
            font-size: 28px;
            font-weight: bold;
        }
        .price {
            color: green;
            font-size: 22px;
            margin: 10px 0;
        }
        .desc {
            margin-top: 15px;
            font-size: 16px;
        }
        .btn-back {
            margin-top: 20px;
        }
        .review-section {
            margin-top: 50px;
            border-top: 1px solid #eee;
            padding-top: 30px;
        }
        .review-item {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .review-rating {
            color: #ffc107; /* Bootstrap yellow for stars */
        }
        .review-form {
            margin-top: 30px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="product-detail-container">
        <div>
            <img src="${plant.imageUrl}" alt="${plant.name}">
        </div>
        <div class="product-info">
            <h2>${plant.name}</h2>
            <div class="price">Giá: <fmt:formatNumber value="${plant.price}" type="currency" currencySymbol="₫" /></div>
            <p><strong>Số lượng còn lại:</strong> ${plant.stockQuantity}</p>
            <div class="desc">${plant.description}</div>

            <form action="${pageContext.request.contextPath}/cart" method="post" class="mt-3">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="plantId" value="${plant.plantId}">
                <input type="number" name="quantity" value="1" min="1" max="${plant.stockQuantity}" class="form-control mb-2" style="width: 100px;">
                <button type="submit" class="btn btn-success">Thêm vào giỏ hàng</button>
            </form>

            <a href="${pageContext.request.contextPath}/plantList" class="btn btn-secondary btn-back">← Quay lại danh sách</a>
        </div>
    </div>

    <div class="review-section">
        <h3>Đánh giá sản phẩm</h3>
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType}">${message}</div>
        </c:if>

        <c:choose>
            <c:when test="${hasPurchased}">
                <div class="review-form">
                    <h4>Gửi đánh giá của bạn</h4>
                    <form action="${pageContext.request.contextPath}/review" method="post">
                        <input type="hidden" name="plantId" value="${plant.plantId}">
                        <div class="mb-3">
                            <label for="rating" class="form-label">Số sao:</label>
                            <select class="form-select" id="rating" name="rating" required>
                                <option value="5">5 sao</option>
                                <option value="4">4 sao</option>
                                <option value="3">3 sao</option>
                                <option value="2">2 sao</option>
                                <option value="1">1 sao</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="comment" class="form-label">Bình luận:</label>
                            <textarea class="form-control" id="comment" name="comment" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info">Bạn cần mua sản phẩm này để có thể gửi đánh giá.</div>
            </c:otherwise>
        </c:choose>

        <h4 class="mt-4">Các đánh giá khác</h4>
        <c:choose>
            <c:when test="${empty reviews}">
                <p>Chưa có đánh giá nào cho sản phẩm này.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews}">
                    <div class="review-item">
                        <p><strong>${review.userName}</strong> - 
                            <span class="review-rating">
                                <c:forEach begin="1" end="${review.rating}">
                                    <i class="fas fa-star"></i>
                                </c:forEach>
                                <c:forEach begin="${review.rating + 1}" end="5">
                                    <i class="far fa-star"></i>
                                </c:forEach>
                            </span>
                            <small class="text-muted"> (<fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm" />)</small>
                        </p>
                        <p>${review.comment}</p>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
