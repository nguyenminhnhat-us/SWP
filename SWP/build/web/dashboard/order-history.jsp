<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử đơn hàng</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">Lịch sử đơn hàng của bạn</h2>

    <!-- Nav Tabs -->
    <ul class="nav nav-tabs" id="orderTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="product-tab" data-bs-toggle="tab" data-bs-target="#product" type="button" role="tab">
                Đơn mua sản phẩm
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="care-tab" data-bs-toggle="tab" data-bs-target="#care" type="button" role="tab">
                Đơn chăm sóc cây
            </button>
        </li>
    </ul>

    <div class="tab-content mt-3" id="orderTabsContent">
        <!-- TAB 1: Đơn sản phẩm -->
        <div class="tab-pane fade show active" id="product" role="tabpanel" aria-labelledby="product-tab">
            <c:if test="${empty orders}">
                <div class="alert alert-info mt-3">Bạn chưa có đơn hàng nào.</div>
            </c:if>
            <c:if test="${not empty orders}">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th>Địa chỉ giao hàng</th>
                            <th>Thanh toán</th>
                            <th>Tổng tiền</th>
                            <th>Chi tiết</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.createdAt}</td>
                                <td>${order.status}</td>
                                <td>${order.shippingAddress}</td>
                                <td>${order.paymentMethod}</td>
                                <td>${order.totalAmount}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/dashboard/order-history?orderId=${order.orderId}" class="btn btn-sm btn-primary">
                                        Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>

<!-- TAB 2: Đơn chăm sóc cây -->
<div class="tab-pane fade" id="care" role="tabpanel" aria-labelledby="care-tab">
    <h2 class="mb-4">🌿 Đơn chăm sóc cây</h2>

    <c:if test="${not empty careCarts}">
        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-success">
                    <tr>
                        <th>ID</th>
                        <th>Tên cây</th>
                        <th>Ngày hẹn</th>
                        <th>Giờ hẹn</th>
                        <th>Vị trí</th>
                        <th>Địa chỉ</th>
                        <th>Số giờ/ngày</th>
                        <th>Ghi chú</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cart" items="${careCarts}">
                        <tr>
                            <td>${cart.cartId}</td>
                            <td>${cart.plantName}</td>
                            <td>${cart.dropOffDate}</td>
                            <td>${cart.appointmentTime}</td>
                            <td>${cart.locationType}</td>
                            <td>${cart.homeAddress}</td>
                            <td>${cart.hoursPerDay}</td>
                            <td>${cart.notes}</td>
                            <td><fmt:formatNumber value="${cart.totalPrice}" type="currency"/></td>
                            <td>${cart.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <c:if test="${empty careCarts}">
        <div class="alert alert-info">Chưa có đơn chăm sóc cây nào.</div>
    </c:if>
</div>

    </div>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
