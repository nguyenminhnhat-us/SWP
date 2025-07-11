<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - ID: ${order.orderId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="../css/header-style.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-2 col-md-3 sidebar p-0">
                <jsp:include page="../common/dashboard/sidebar.jsp" />
            </div>
            <div class="col-lg-10 col-md-9 main-content">
                <h2 class="mb-4 mt-3">Chi tiết đơn hàng</h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <c:choose>
                    <c:when test="${order == null}">
                        <div class="alert alert-warning">Không tìm thấy đơn hàng này.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="card mb-4">
                            <div class="card-header">
                                Thông tin đơn hàng #${order.orderId}
                            </div>
                            <div class="card-body">
                                <p><strong>ID Người dùng:</strong> ${order.userId}</p>
                                <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" /></p>
                                <p><strong>Trạng thái:</strong> ${order.status}</p>
                                <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress}</p>
                                <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</p>
                                <p><strong>Ngày đặt hàng:</strong> <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></p>
                            </div>
                        </div>

                        <!-- Admin: Update Order Status Form -->
                        <c:set var="currentUser" value="${sessionScope.user}" />
                        <c:if test="${currentUser != null && 'admin' eq currentUser.role}">
                            <div class="card mb-4">
                                <div class="card-header">
                                    Cập nhật trạng thái đơn hàng
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/dashboard/order-history" method="post">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <div class="mb-3">
                                            <label for="status" class="form-label">Trạng thái mới:</label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="pending" <c:if test="${order.status eq 'pending'}">selected</c:if>>Pending</option>
                                                <option value="processing" <c:if test="${order.status eq 'processing'}">selected</c:if>>Processing</option>
                                                <option value="shipped" <c:if test="${order.status eq 'shipped'}">selected</c:if>>Shipped</option>
                                                <option value="delivered" <c:if test="${order.status eq 'delivered'}">selected</c:if>>Delivered</option>
                                                <option value="cancelled" <c:if test="${order.status eq 'cancelled'}">selected</c:if>>Cancelled</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                                    </form>
                                </div>
                            </div>
                        </c:if>

                        <div class="card mb-4">
                            <div class="card-header">
                                Sản phẩm trong đơn hàng
                            </div>
                            <div class="card-body">
                                <c:if test="${empty orderDetails}">
                                    <p>Không có sản phẩm nào trong đơn hàng này.</p>
                                </c:if>
                                <c:if test="${not empty orderDetails}">
                                    <table class="table table-striped table-bordered">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID Sản phẩm</th>
                                                <th>Tên sản phẩm</th>
                                                <th>Số lượng</th>
                                                <th>Đơn giá</th>
                                                <th>Tổng</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="detail" items="${orderDetails}">
                                                <tr>
                                                    <td>${detail.plantId}</td>
                                                    <td>
                                                        <c:set var="plantDAO" value="${requestScope.plantDAO}" />
                                                        <c:if test="${plantDAO == null}">
                                                            <jsp:useBean id="plantDAO" class="dal.PlantDAO" scope="request" />
                                                        </c:if>
                                                        <c:set var="plant" value="${plantDAO.getPlantById(detail.plantId)}" />
                                                        ${plant.name}
                                                    </td>
                                                    <td>${detail.quantity}</td>
                                                    <td><fmt:formatNumber value="${detail.unitPrice}" type="currency" currencySymbol="₫" /></td>
                                                    <td><fmt:formatNumber value="${detail.unitPrice * detail.quantity}" type="currency" currencySymbol="₫" /></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:if>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/dashboard/order-history" class="btn btn-secondary">Quay lại lịch sử đơn hàng</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
