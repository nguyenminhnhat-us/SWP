<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quên mật khẩu</title>
</head>
<body>
    <h2>Quên mật khẩu</h2>
    <form action="forgot-password" method="post">
        <label>Email:</label>
        <input type="email" name="email" required>
        <button type="submit">Gửi mã OTP</button>
    </form>

    <p style="color:red;"><%= request.getAttribute("errorMsg") != null ? request.getAttribute("errorMsg") : "" %></p>
    <p style="color:green;"><%= request.getAttribute("successMsg") != null ? request.getAttribute("successMsg") : "" %></p>
</body>
</html>
