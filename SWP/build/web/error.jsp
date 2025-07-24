<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi - Vườn Cây Đà Nẵng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #171717; color: white; }
    </style>
</head>
<body>
    <div class="container my-4 text-center">
        <h2 class="text-danger">Đã xảy ra lỗi</h2>
        <p>${error != null ? error : 'Đã có lỗi xảy ra. Vui lòng thử lại sau.'}</p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-success">Quay lại trang chủ</a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>