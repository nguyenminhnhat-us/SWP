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
    <link rel="stylesheet" href="../css/login-style.css">
</head>
<body>
    <h1>Chào m?ng Admin: <%= user.getFullName() %></h1>
    <p>?ây là trang qu?n tr?</p>
    <a href="../logout">??ng xu?t</a>
</body>
</html>

