<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quên mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/login-style.css">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Quên mật khẩu</h2>
        <form action="forgot-password" method="post" class="mt-3">
            <div class="mb-3">
                <label for="email" class="form-label">Email:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <button type="submit" class="btn btn-primary">Gửi mã OTP</button>
        </form>

        <p class="mt-3" style="color:red;"><%= request.getAttribute("errorMsg") != null ? request.getAttribute("errorMsg") : "" %></p>
        <p class="mt-3" style="color:green;"><%= request.getAttribute("successMsg") != null ? request.getAttribute("successMsg") : "" %></p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
