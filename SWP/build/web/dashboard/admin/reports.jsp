    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <!DOCTYPE html>
    <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <title>Báo cáo doanh thu</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        </head>
        <body>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-2 col-md-3 sidebar p-0">
                        <jsp:include page="../../common/dashboard/sidebar.jsp" />
                    </div>
                    <div class="col-lg-10 col-md-9 main-content p-4">
                        <h2 class="mb-4 mt-3 text-success"><i class="fa fa-chart-line me-2"></i> Báo cáo doanh thu</h2>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <!-- Form lọc theo thời gian -->
                        <div class="card card-custom mb-4">
                            <div class="card-header card-header-custom">
                                <h5 class="mb-0">Lọc doanh thu theo thời gian</h5>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/dashboard/reports" method="get" class="row g-3 align-items-end">
                                    <div class="col-md-4">
                                        <label for="startDate" class="form-label">Từ ngày:</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" 
                                               value="${startDate}" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="endDate" class="form-label">Đến ngày:</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" 
                                               value="${endDate}" required>
                                    </div>
                                    <div class="col-md-4">
                                        <button type="submit" class="btn btn-custom text-white">Lọc</button>
                                        <a href="${pageContext.request.contextPath}/dashboard/reports" 
                                           class="btn btn-secondary">Xóa bộ lọc</a>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Biểu đồ doanh thu -->
                        <div class="card card-custom mb-4">
                            <div class="card-header card-header-custom">
                                <h5 class="mb-0">Biểu đồ doanh thu theo ngày</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>

<!-- Tổng doanh thu đơn hàng -->
<div class="card card-custom mb-4">
    <div class="card-header card-header-custom">
        <h5 class="mb-0">Tổng doanh thu (Đơn hàng đã giao
            <c:if test="${not empty startDate and not empty endDate}">
                từ ${startDate} đến ${endDate}
            </c:if>)</h5>
    </div>
    <div class="card-body">
        <h3 class="text-success">
            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" />
        </h3>
    </div>
</div>

<!-- Tổng doanh thu đơn chăm sóc cây -->
<div class="card card-custom mb-4">
    <div class="card-header card-header-custom">
        <h5 class="mb-0">Tổng doanh thu (Đơn chăm sóc cây đã hoàn thành
            <c:if test="${not empty startDate and not empty endDate}">
                từ ${startDate} đến ${endDate}
            </c:if>)</h5>
    </div>
    <div class="card-body">
        <h3 class="text-primary">
            <fmt:formatNumber value="${totalCareRevenue}" type="currency" currencySymbol="₫" />
        </h3>
    </div>
</div>

<!-- Bảng đơn hàng đã giao -->
<c:choose>
    <c:when test="${empty deliveredOrders}">
        <div class="alert alert-info">Chưa có đơn hàng nào được giao
            <c:if test="${not empty startDate and not empty endDate}">
                trong khoảng thời gian từ ${startDate} đến ${endDate}.
            </c:if>
        </div>
    </c:when>
    <c:otherwise>
        <div class="card card-custom">
            <div class="card-header card-header-custom">
                <h5 class="mb-0">Chi tiết đơn hàng đã giao</h5>
            </div>
            <div class="card-body">
                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Đơn hàng</th>
                            <th>ID Người dùng</th>
                            <th>Tổng tiền</th>
                            <th>Địa chỉ giao hàng</th>
                            <th>Phương thức thanh toán</th>
                            <th>Ngày đặt hàng</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${deliveredOrders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.userId}</td>
                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" /></td>
                                <td>${order.shippingAddress}</td>
                                <td>${order.paymentMethod}</td>
                                <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/dashboard/order-history?orderId=${order.orderId}" 
                                       class="btn btn-info btn-sm">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<!-- Bảng đơn chăm sóc cây đã hoàn thành -->
<c:choose>
    <c:when test="${empty deliveredCareCarts}">
        <div class="alert alert-info">Chưa có đơn chăm sóc cây nào được hoàn thành
            <c:if test="${not empty startDate and not empty endDate}">
                trong khoảng thời gian từ ${startDate} đến ${endDate}.
            </c:if>
        </div>
    </c:when>
    <c:otherwise>
        <div class="card card-custom mt-4">
            <div class="card-header card-header-custom">
                <h5 class="mb-0">Chi tiết đơn chăm sóc cây đã hoàn thành</h5>
            </div>
            <div class="card-body">
                <table class="table table-striped table-bordered">
                    <thead class="table-success">
                        <tr>
                            <th>ID Đơn</th>
                            <th>ID Người dùng</th>
                            <th>Tên cây</th>
                            <th>Ngày hẹn</th>
                            <th>Giờ hẹn</th>
                            <th>Vị trí</th>
                            <th>Địa chỉ</th>
                            <th>Số giờ/ngày</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cart" items="${deliveredCareCarts}">
                            <tr>
                                <td>${cart.cartId}</td>
                                <td>${cart.userId}</td>
                                <td>${cart.plantName}</td>
                                <td><fmt:formatDate value="${cart.dropOffDate}" pattern="dd/MM/yyyy" /></td>
                                <td>${cart.appointmentTime}</td>
                                <td>${cart.locationType}</td>
                                <td>${cart.homeAddress}</td>
                                <td>${cart.hoursPerDay}</td>
                                <td><fmt:formatNumber value="${cart.totalPrice}" type="currency" currencySymbol="₫" /></td>
                                <td>${cart.status}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:otherwise>
</c:choose>
                    </div>
                </div>
            </div>

            <!-- Script để vẽ biểu đồ -->
            <script>
                const ctx = document.getElementById('revenueChart').getContext('2d');
                const revenueData = {
                    labels: [
                <c:forEach var="entry" items="${revenueByDay}">
                    "${entry.key}",
                </c:forEach>
                    ],
                    datasets: [{
                            label: 'Doanh thu (VND)',
                            data: [
                <c:forEach var="entry" items="${revenueByDay}">
                    ${entry.value},
                </c:forEach>
                            ],
                            borderColor: '#28a745',
                                    backgroundColor: 'rgba(40, 167, 69, 0.2)',
                            fill: true,
                                    tension: 0.4
                        }]
                };
                new Chart(ctx, {
                    type: 'line',
                    data: revenueData,
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function (value) {
                                        return value.toLocaleString('vi-VN') + ' ₫';
                                    }
                                }
                            }
                        },
                        plugins: {
                            legend: {display: true},
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        return context.dataset.label + ': ' + context.parsed.y.toLocaleString('vi-VN') + ' ₫';
                                    }
                                }
                            }
                        }
                    }
                });
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>