<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"expert".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Chuyên Gia</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h4>Xin chào chuyên gia <%= user.getFullName() %></h4>
        </div>
        <div class="card-body">
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Vai trò:</strong> <%= user.getRole() %></p>

            <hr>

            <h5>🔧 Chức năng dành cho chuyên gia:</h5>
            <ul class="list-group list-group-flush">
                <li class="list-group-item">
                <a href="<%= request.getContextPath() %>/care-orders">🌿 Quản lý cây đang chăm sóc</a>
            </li>
                <li class="list-group-item"><a href="write-article.jsp">📚 Viết bài tư vấn</a></li>
                <li class="list-group-item"><a href="logout.jsp">🚪 Đăng xuất</a></li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
