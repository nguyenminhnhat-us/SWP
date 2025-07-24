<%-- 
    Document   : home
    Created on : May 30, 2025, 10:56:47 AM
    Author     : ADMIN
--%>

<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Trang ch?</title>
</head>
<body>
    <h2>Xin chào, <%= user.getFullName() %>!</h2>
    <p>Email: <%= user.getEmail() %></p>
</body>
</html>

