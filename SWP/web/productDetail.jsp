<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Chi tiết sản phẩm</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                    <link rel="stylesheet" href="css/header-style.css">
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </head>

                <body>
                    <c:set var="product" value="${productMap.product}" />
                    <c:set var="categoryName" value="${productMap.categoryName}" />
                    <jsp:include page="./common/home/header.jsp" />
                    <div class="container my-4">
                        <div class="row">
                            <!-- Thông tin sản phẩm -->
                            <div class="col-lg-8 mb-4">
                                <div class="card mb-4">
                                    <div class="row g-0">
                                        <div
                                            class="col-md-5 text-center p-3 d-flex align-items-center justify-content-center">
                                            <img src="${product.imageUrl}" alt="${product.name}" class="product-image">
                                        </div>
                                        <div class="col-md-7 d-flex align-items-center">
                                            <div class="card-body">
                                                <h2 class="card-title">${product.name}</h2>
                                                <p class="card-text">${product.description}</p>
                                                <p class="mb-2"><b>Giá:</b> <span class="text-success fs-4">
                                                        <fmt:formatNumber value="${product.price}" type="currency"
                                                            currencySymbol="₫" />
                                                    </span></p>
                                                <p><b>Số lượng còn:</b> ${product.stockQuantity}</p>
                                                <p><b>Danh mục:</b> ${categoryName}</p>
                                                <form action="${pageContext.request.contextPath}/cart" method="post"
                                                    class="d-inline">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="plantId" value="${product.plantId}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ hàng
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Feedback -->
                                <div class="feedback-section mb-4">
                                    <h4 class="mb-3">Phản hồi của khách hàng</h4>
                                    <c:forEach var="fb" items="${feedbackList}">
                                        <c:set var="review" value="${fb.review}" />
                                        <div class="mb-3 border-bottom pb-2">
                                            <b>${fb.userName}</b>
                                            <span class="text-warning">${review.rating} <i
                                                    class="fas fa-star"></i></span>
                                            <p class="mb-1">${review.comment}</p>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy" />
                                            </small>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty feedbackList}">
                                        <p>Chưa có phản hồi nào cho sản phẩm này.</p>
                                    </c:if>
                                </div>
                                <!-- Review Section -->
                                <div class="feedback-section mb-4">
                                    <h4 class="mb-3">Đánh giá sản phẩm</h4>
                                    <c:if test="${not empty message}">
                                        <div class="alert alert-${messageType}">${message}</div>
                                    </c:if>

                                    <c:choose>
                                        <c:when test="${hasPurchased}">
                                            <div class="review-form">
                                                <h6>Gửi đánh giá của bạn</h6>
                                                <form action="${pageContext.request.contextPath}/review" method="post">
                                                    <input type="hidden" name="plantId" value="${product.plantId}">
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
                                </div>
                                <!-- Sản phẩm liên quan -->
                                <div class="mb-4">
                                    <h4 class="mb-3">Sản phẩm liên quan</h4>
                                    <div class="related-slider">
                                        <c:forEach var="rel" items="${relatedPlants}">
                                            <div class="card h-100">
                                                <img src="${rel.imageUrl}" class="card-img-top" alt="${rel.name}"
                                                    style="height: 200px; object-fit: cover;">
                                                <div class="card-body d-flex flex-column">
                                                    <h6 class="card-title">${rel.name}</h6>
                                                    <p class="price mb-2">
                                                        <fmt:formatNumber value="${rel.price}" type="currency"
                                                            currencySymbol="₫" />
                                                    </p>
                                                    <a href="product-detail?id=${rel.plantId}"
                                                        class="btn btn-outline-success btn-sm mt-auto">Xem chi tiết</a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <!-- Sidebar phải -->
                            <div class="col-lg-4">
                                <div class="sidebar-section mb-4">
                                    <h5 class="mb-3">Bài viết mới nhất</h5>
                                    <c:forEach var="article" items="${latestArticles}">
                                        <div class="mb-2">
                                            <a href="#" class="fw-bold">${article.title}</a>
                                            <div class="text-muted small mb-1">${article.category}</div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <div class="sidebar-section">
                                    <h5 class="mb-3">Sản phẩm bán chạy</h5>
                                    <c:forEach var="plant" items="${topSellingPlants}">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="${plant.imageUrl}" alt="${plant.name}"
                                                style="width:40px;height:40px;object-fit:cover;border-radius:5px;">
                                            <div class="ms-2">
                                                <a href="product-detail?id=${plant.plantId}"
                                                    class="fw-bold">${plant.name}</a>
                                                <div class="text-success small">
                                                    <fmt:formatNumber value="${plant.price}" type="currency"
                                                        currencySymbol="₫" />
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                    <jsp:include page="./common/home/footer.jsp" />
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>
