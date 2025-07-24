<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn được phân công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>z
<body class="container mt-4">

    <h2 class="mb-4">📋 Danh sách đơn chăm sóc cây được giao</h2>
<a href="index.jsp" class="btn btn-outline-secondary mb-3">🏠 Về trang chủ</a>
    <c:if test="${empty assignedCarts}">
        <div class="alert alert-info">Không có đơn hàng nào.</div>
    </c:if>

    <c:if test="${not empty assignedCarts}">
        <p class="text-muted">Tổng số đơn: ${fn:length(assignedCarts)}</p>

        <table class="table table-bordered table-hover align-middle">
            <thead class="table-success text-center">
                <tr>
                    <th>Mã đơn</th>
                    <th>Tên cây</th>
                    <th>Ngày hẹn</th>
                    <th>Giờ</th>
                    <th>Địa chỉ</th>
                    <th>Ghi chú</th>
                    <th>Giá</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${assignedCarts}">
                    <tr>
                        <td class="text-center">${order.cartId}</td>
                        <td>${order.plantName}</td>
                        <td><fmt:formatDate value="${order.dropOffDate}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${order.appointmentTime}" type="time" pattern="HH:mm"/></td>
                        <td>${order.homeAddress}</td>
                        <td>${order.notes}</td>
                        <td><fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/></td>
                        <td>
                            <form method="post" action="approve-care-cart" class="d-flex align-items-center">
                                <input type="hidden" name="cartId" value="${order.cartId}" />
                                <select name="status" class="form-select form-select-sm w-auto me-2">
                                    <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chờ duyệt</option>
                                    <option value="approved" ${order.status == 'approved' ? 'selected' : ''}>Đã duyệt</option>
                                    <option value="rejected" ${order.status == 'rejected' ? 'selected' : ''}>Từ chối</option>
                                    <option value="in_progress" ${order.status == 'in_progress' ? 'selected' : ''}>Đang chăm sóc</option>
                                    <option value="completed" ${order.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-primary">Cập nhật</button>
                            </form>
                        </td>
                        <td class="text-center">
                            <a href="care-cart-detail.jsp?cartId=${order.cartId}" class="btn btn-outline-info btn-sm">Xem</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

</body>
</html>
