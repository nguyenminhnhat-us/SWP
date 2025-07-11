<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng ký Google - Nhập Email</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/registergoole-style.css">
</head>
<body>
    <div class="form-container">
        <h2>Nhập email Google của bạn để nhận OTP</h2>

        <%-- Hiển thị message lỗi nếu có (lấy từ session) --%>
        <%
            String message = (String) session.getAttribute("message");
            if (message != null) {
        %>
            <p class="error-message"><%= message %></p>
        <%
            session.removeAttribute("message");
            }
        %>

        <form action="${pageContext.request.contextPath}/registerGoogle" method="post">
            <input type="email" name="email" placeholder="Email Google" required>
            <button type="submit">Gửi OTP</button>
        </form>
    </div>
</body>
</html>
