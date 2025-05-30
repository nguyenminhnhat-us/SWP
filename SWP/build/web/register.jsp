<%-- 
    Document   : register
    Created on : 24 thg 5, 2025, 15:18:41
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Đăng ký</title>
        <link rel="stylesheet" href="css/register-style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    </head>
    <body>
        <div class="register-wrapper">
            <div class="register-box">
                <h2><i class="fas fa-seedling"></i> Đăng ký tài khoản</h2>

                <% String errorMsg = (String) request.getAttribute("errorMsg"); %>
                <% if (errorMsg != null) {%>
                <p style="color: red; text-align: center;"><%= errorMsg%></p>
                <% }%>

                <form action="register" method="post" class="form-group">
                    <label for="full_name" class="form-label">Họ và tên:</label>
                    <input type="text" class="form-control" name="full_name" id="full_name" required>

                    <label for="email" class="form-label">Email:</label>
                    <input type="email" class="form-control" name="email" id="email"
                           pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" required
                           title="Email phải đúng định dạng, ví dụ: example@email.com">

                    <label for="password" class="form-label">Mật khẩu:</label>
                    <input type="password" class="form-control" name="password" id="password" minlength="6" required>

                    <label for="phone" class="form-label">Số điện thoại:</label>
                    <input type="text" class="form-control" name="phone" id="phone"
       pattern="[0-9]{10}" required
       title="Số điện thoại phải gồm đúng 10 chữ số">
                    <label for="address" class="form-label">Địa chỉ:</label>
                    <input type="text" class="form-control" name="address" id="address" required>

                    <button type="submit" class="btn btn-success">Đăng ký</button><br><br>

                    <!-- Nút đăng ký Google -->
                    <div class="text-center mt-3">
                        <a href="https://accounts.google.com/o/oauth2/auth?client_id=877308457870-12adf40qri6e508nsue8s9ipe5mtmhr4.apps.googleusercontent.com&redirect_uri=http://localhost:8080/SWP/register-google&response_type=code&scope=email%20profile"
                           class="btn-google">
                            <i class="fab fa-google"></i> Đăng ký với Google
                        </a>
                    </div>

                    <p class="text-center mt-3">Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>

                </form>

            </div>
        </div>
    </body>
</html>