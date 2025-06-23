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
        <style>
            body {
                background-color: #171717;
                color: white;
            }
            .cart-table {
                background-color: #2e2e2e;
                border-radius: 8px;
            }
            .cart-table th, .cart-table td {
                vertical-align: middle;
            }
            .btn-action {
                margin: 5px;
            }
            .total-section {
                font-size: 1.2rem;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container my-4">
            <h2 class="text-success text-center">Giỏ hàng của bạn</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
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
                        <a href="${pageContext.request.contextPath}/checkout.jsp" class="btn btn-success">Thanh toán</a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Quay lại</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>