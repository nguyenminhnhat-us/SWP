<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng ký tài khoản</title>
    <link rel="stylesheet" href="css/register-style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
<div class="register-wrapper">
    <div class="register-box">
        <h2><i class="fas fa-seedling"></i> Đăng ký tài khoản</h2>

        <% 
           String errorMsg = (String) request.getAttribute("errorMsg");
           String message = (String) request.getAttribute("message");
        %>
        <% if (errorMsg != null) { %>
            <p style="color: red; text-align: center;"><%= errorMsg %></p>
        <% } %>
        <% if (message != null) { %>
            <p style="color: green; text-align: center;"><%= message %></p>
        <% } %>

        <form action="register" method="post" class="form-group">

    <label for="email">Email:</label>
    <input type="email" name="email" id="email" required>
    <label for="full_name">Họ và tên:</label>
    <input type="text" name="full_name" id="full_name" required>
    <label for="password">Mật khẩu:</label>
    <input type="password" name="password" id="password" minlength="6" required>

    <label for="phone">Số điện thoại:</label>
    <input type="text" name="phone" id="phone" required>

    <label for="address">Địa chỉ:</label>
    <input type="text" name="address" id="address" required>

    <button type="submit">Đăng ký</button>
</form>


        <!-- Nút đăng ký bằng Google -->
        <div class="text-center mt-3">
            <a href="registerGoogle.jsp" class="btn-google btn btn-danger">
                <i class="fab fa-google"></i> Đăng ký với Google
            </a>
        </div>

        <p class="text-center mt-3">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
    </div>
</div>
</body>
</html>
