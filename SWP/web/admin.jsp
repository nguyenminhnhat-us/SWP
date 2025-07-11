<%-- 
    Document   : admin
    Created on : 23 thg 5, 2025, 10:46:11
    Author     : ADMIN
--%>

<%@ page import="model.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="../css/login-style.css">
</head>
<body>
    <h1>Ch�o m?ng Admin: <%= user.getFullName() %></h1>
    <p>?�y l� trang qu?n tr?</p>
    <a href="../logout">??ng xu?t</a>
</body>
</html>

