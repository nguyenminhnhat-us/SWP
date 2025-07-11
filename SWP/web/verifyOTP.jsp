<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Xác minh OTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/registergoole-style.css"> <!-- Hoặc file CSS bạn đang dùng chung -->
</head>
<body>
    <div class="form-container">
        <h2>Nhập mã OTP đã gửi qua email</h2>
        <form action="${pageContext.request.contextPath}/verifyOTP" method="post">
            <input type="text" name="otp" placeholder="Nhập mã OTP" required>
            <button type="submit">Xác minh</button>
        </form>
        <p class="error-message">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </p>
    </div>
</body>
</html>
