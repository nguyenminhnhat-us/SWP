<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý dịch vụ chăm sóc</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body>
<div class="container mt-5">
    <h2>Care Packages: Edit Care Services</h2>

    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên dịch vụ</th>
            <th>Mô tả</th>
            <th>Giá cố định</th>
            <th>Số ngày</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="s" items="${services}">
            <tr>
                <!-- Form Sửa -->
                <form method="post" action="${pageContext.request.contextPath}/dashboard/care-services/update">
                    <td>
                        ${s.serviceId}
                        <input type="hidden" name="serviceId" value="${s.serviceId}" />
                    </td>
                    <td><input type="text" class="form-control" name="name" value="${s.name}" required /></td>
                    <td><input type="text" class="form-control" name="description" value="${s.description}" /></td>
                    <td><input type="number" step="0.01" class="form-control" name="price" value="${s.price}" required /></td>
                    <td><input type="number" class="form-control" name="durationDays" value="${s.durationDays}" required /></td>
                    <td>
                        <button type="submit" class="btn btn-sm btn-success">Lưu</button>
                    </td>
                </form>

                <!-- Form Xóa (riêng biệt ngoài form sửa) -->
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/dashboard/care-services/delete" onsubmit="return confirm('Bạn có chắc muốn xóa dịch vụ này không?')">
                        <input type="hidden" name="id" value="${s.serviceId}" />
                        <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
