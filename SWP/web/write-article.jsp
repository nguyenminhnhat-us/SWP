<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Viết bài chia sẻ</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">Viết bài chia sẻ</h2>

    <!-- Hiển thị thông báo thành công hoặc lỗi -->
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="post-article" method="post">
        <div class="mb-3">
            <label for="title" class="form-label">Tiêu đề</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>

        <div class="mb-3">
            <label for="category" class="form-label">Chuyên mục</label>
            <select class="form-select" id="category" name="category" required>
                <option value="">-- Chọn chuyên mục --</option>
                <option value="Chăm sóc cây">Chăm sóc cây</option>
                <option value="Phong thủy">Phong thủy</option>
                <option value="Sức khỏe">Sức khỏe</option>
                <option value="Không gian sống">Không gian sống</option>
                <option value="Kỹ thuật">Kỹ thuật</option>
                <option value="Gợi ý mua sắm">Gợi ý mua sắm</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">Nội dung</label>
            <textarea class="form-control" id="content" name="content" rows="10" required></textarea>
        </div>

        <button type="submit" class="btn btn-success">Đăng bài</button>
    </form>
</div>
</body>
</html>
