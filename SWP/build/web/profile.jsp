<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = user.getFullName();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân</title>
</head>
<body>
    <h1>Hồ sơ cá nhân</h1>
    <p>Tên người dùng: <strong><%= username %></strong></p>

    <form action="change-password.jsp" method="get">
        <button type="submit">Đổi mật khẩu</button>
    </form>
</body>
</html>
