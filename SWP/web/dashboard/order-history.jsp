<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<<<<<<< HEAD
    <link rel="stylesheet" href="../css/header-style.css">
=======
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-2 col-md-3 sidebar p-0">
                <jsp:include page="../common/dashboard/sidebar.jsp" />
            </div>
            <div class="col-lg-10 col-md-9 main-content">
                <h2 class="mb-4 mt-3">Lịch sử đơn hàng</h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="alert alert-info">Chưa có đơn hàng nào.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-striped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID Đơn hàng</th>
                                    <th>ID Người dùng</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Địa chỉ giao hàng</th>
                                    <th>Phương thức thanh toán</th>
                                    <th>Ngày đặt hàng</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>${order.orderId}</td>
                                        <td>${order.userId}</td>
                                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" /></td>
                                        <td>${order.status}</td>
                                        <td>${order.shippingAddress}</td>
                                        <td>${order.paymentMethod}</td>
                                        <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/dashboard/order-history?orderId=${order.orderId}" class="btn btn-info btn-sm">Xem chi tiết</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
