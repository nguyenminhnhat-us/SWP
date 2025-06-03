<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - Hệ thống cây cảnh</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/login-style.css">
</head>
<body>
<div class="login-wrapper">
    <div class="login-box shadow">
        <h2 class="text-center"><i class="fas fa-seedling me-2"></i>Đăng nhập</h2>

        <% String success = request.getParameter("success");
           if ("1".equals(success)) { %>
            <div class="alert alert-success text-center mb-3">
                <i class="fas fa-check-circle"></i> Đăng ký thành công! Vui lòng đăng nhập.
            </div>
        <% } %>

        <% if (request.getAttribute("errorMsg") != null) { %>
            <div class="alert alert-danger text-center mb-3">
                <%= request.getAttribute("errorMsg") %>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" name="email" id="email" class="form-control" required placeholder="Nhập email">
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Mật khẩu:</label>
                <input type="password" name="password" id="password" class="form-control" required placeholder="Nhập mật khẩu">
            </div>

            <button type="submit" class="btn btn-success w-100 mt-2">Đăng nhập</button>
        </form>

        <!-- Đăng nhập bằng Google -->
        <div class="text-center mt-3">
            <a href="https://accounts.google.com/o/oauth2/auth?client_id=877308457870-12adf40qri6e508nsue8s9ipe5mtmhr4.apps.googleusercontent.com&redirect_uri=http://localhost:8080/SWP/login-google&response_type=code&scope=email%20profile"
               class="btn btn-outline-danger w-100">
                <i class="fab fa-google me-2"></i> Đăng nhập với Google
            </a>
        </div>

        <!-- Quên mật khẩu -->
        <div class="text-end mt-3">
            <a href="#" class="link-danger text-decoration-none" onclick="toggleForgotForm()">Quên mật khẩu?</a>
        </div>

        <!-- Form Quên mật khẩu -->
        <div id="forgotForm" class="mt-4" style="display: none;">
            <h5 class="text-center text-primary">Lấy lại mật khẩu</h5>
            <form action="forgot-password" method="post">
                <div class="mb-3">
                    <label for="forgot-email">Email:</label>
                    <input type="email" name="email" id="forgot-email" class="form-control" required placeholder="Nhập email để nhận OTP">
                </div>
                <button type="submit" class="btn btn-warning w-100">Gửi mã OTP</button>
            </form>
        </div>

        <p class="text-center mt-4">Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
    </div>
</div>

<!-- Toggle form quên mật khẩu -->
<script>
    function toggleForgotForm() {
        const form = document.getElementById("forgotForm");
        form.style.display = (form.style.display === "none") ? "block" : "none";
    }
</script>
</body>
</html>
