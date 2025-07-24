<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch chăm sóc cây</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
    <h2 class="mb-3">📅 Lịch chăm sóc cây của bạn</h2>
    <a href="index.jsp" class="btn btn-outline-secondary mb-3">🏠 Về trang chủ</a>

    <c:if test="${empty schedule}">
        <div class="alert alert-warning">Bạn chưa được phân công chăm sóc cây nào.</div>
    </c:if>

    <c:if test="${not empty schedule}">
        <table class="table table-bordered table-hover">
            <thead class="table-success text-center">
                <tr>
                    <th>Mã đơn</th>
                    <th>Tên cây</th>
                    <th>Ngày chăm sóc</th>
                    <th>Giờ hẹn</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${schedule}">
                    <tr>
                        <td class="text-center">${item.cartId}</td>
                        <td>${item.plantName}</td>
                        <td><fmt:formatDate value="${item.dropOffDate}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${item.appointmentTime}" type="time" pattern="HH:mm"/></td>
                        <td>
                            <span class="badge 
                                ${item.status == 'in_progress' ? 'bg-warning' : 
                                  item.status == 'approved' ? 'bg-success' : 'bg-secondary'}">
                                ${item.status}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</body>
</html>
