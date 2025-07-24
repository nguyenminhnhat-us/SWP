<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Đăng ký Google - Nhập Email</title>
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
