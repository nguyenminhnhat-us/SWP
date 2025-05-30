<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; }
        .login-container { max-width: 400px; margin: auto; padding: 20px; }
        input { width: 100%; padding: 8px; margin: 5px 0; }
        input[type="submit"] { background-color: #4CAF50; color: white; cursor: pointer; }
        .error { color: red; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>
        <form action="login" method="post">
            <label>Email:</label>
            <input type="email" name="email" required><br>
            <label>Mật khẩu:</label>
            <input type="password" name="password" required><br>
            <input type="submit" value="Đăng nhập">
        </form>
        <% if (request.getAttribute("errorMsg") != null) { %>
            <p class="error"><%= request.getAttribute("errorMsg") %></p>
        <% } %>
    </div>
</body>
</html>