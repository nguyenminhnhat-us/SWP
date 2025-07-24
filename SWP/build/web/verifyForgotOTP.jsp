<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Xác minh OTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center">Xác minh mã OTP</h2>
    <form action="verifyForgotOTP" method="post" class="mt-4">

        <div class="mb-3">
            <label class="form-label">Nhập mã OTP đã gửi đến email của bạn:</label>
            <input type="text" name="otp" class="form-control" required>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <button type="submit" class="btn btn-primary w-100">Xác minh</button>
    </form>
</div>
</body>
</html>
