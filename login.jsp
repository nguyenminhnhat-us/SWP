<%-- 
    Document   : login
    Created on : 20 thg 5, 2025, 14:34:24
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - Quản lý cây cảnh</title>
    <link rel="stylesheet" type="text/css" href="css/login-style.css">
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Email" required />
            <input type="password" name="password" placeholder="Mật khẩu" required />
            <button type="submit">Đăng nhập</button>
        </form>

        <% String errorMsg = (String) request.getAttribute("errorMsg");
           if (errorMsg != null) { %>
            <div class="error-msg"><%= errorMsg %></div>
        <% } %>
    </div>
</body>
</html>

