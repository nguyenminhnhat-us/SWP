<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Giỏ hàng - Vườn Cây Đà Nẵng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="css/header-style.css">
    </head>
    <body>
        <jsp:include page="/common/home/header.jsp" />
        <div class="container my-4">
            <h2 class="text-success text-center">Giỏ hàng của bạn</h2>
<<<<<<< HEAD
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType}">${message}</div>
=======
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
>>>>>>> d29c17d75eb1624e175c8b09a64d09bbe9fcb6e2
            </c:if>
            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="alert alert-info text-center">Giỏ hàng của bạn đang trống.</div>
                    <div class="text-center">
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-success">Tiếp tục mua sắm</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table cart-table">
                        <thead class="table-success">
                            <tr>
                                <th>Hình ảnh</th>
                                <th>Tên cây</th>
                                <th>Giá</th>
                                <th>Số lượng</th>
                                <th>Tổng</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td><img src="${item.plant.imageUrl}" alt="${item.plant.name}" style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px;"></td>
                                    <td>${item.plant.name}</td>
                                    <td><fmt:formatNumber value="${item.plant.price}" type="currency" currencySymbol="₫" /></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="plantId" value="${item.plantId}">
                                            <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.plant.stockQuantity}" class="form-control d-inline-block" style="width: 80px;">
                                            <button type="submit" class="btn btn-warning btn-sm btn-action"><i class="fas fa-sync"></i></button>
                                        </form>
                                    </td>
                                    <td><fmt:formatNumber value="${item.plant.price * item.quantity}" type="currency" currencySymbol="₫" /></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="plantId" value="${item.plantId}">
                                            <button type="submit" class="btn btn-danger btn-sm btn-action"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div class="total-section text-end">
                        <p>Tổng tiền: <fmt:formatNumber value="${total}" type="currency" currencySymbol="₫" /></p>
                    </div>
                    <div class="text-end mt-3">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-inline">
                            <input type="hidden" name="action" value="clear">
                            <button type="submit" class="btn btn-danger">Xóa toàn bộ</button>
                        </form>
<<<<<<< HEAD
                        <form action="${pageContext.request.contextPath}/cart" method="get" class="d-inline">
                            <input type="hidden" name="action" value="process-checkout">
                            <button type="submit" class="btn btn-success">Mua hàng</button>
                        </form>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Quay lại</a>
=======
                        <a href="${pageContext.request.contextPath}/checkout.jsp" class="btn btn-success">Thanh toán</a>
<<<<<<< HEAD
=======
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Quay lại</a>
>>>>>>> d29c17d75eb1624e175c8b09a64d09bbe9fcb6e2
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> d29c17d75eb1624e175c8b09a64d09bbe9fcb6e2
