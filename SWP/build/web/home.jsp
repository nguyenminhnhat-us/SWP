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
    <title>Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header-style.css">
</head>
<body>
    <h2>Xin chào, <%= user.getFullName() %>!</h2>
    <p>Email: <%= user.getEmail() %></p>
</body>
</html>

