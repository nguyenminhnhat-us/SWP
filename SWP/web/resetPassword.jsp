<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đặt lại mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/login-style.css">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Đặt lại mật khẩu</h2>
        <form action="reset-password" method="post" class="mt-3">
            <div class="mb-3">
                <label class="form-label">Mật khẩu mới:</label>
                <input type="password" name="newPassword" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Cập nhật</button>
        </form>
    </div>
</body>
</html>
