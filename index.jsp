<%-- 
    Document   : index
    Created on : 20 thg 5, 2025, 14:59:55
    Author     : ADMIN
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<h1>Chào mừng <%= user.getFullName() %> đến với hệ thống quản lý cây cảnh!</h1>
<a href="logout">Đăng xuất</a>
</body>
</html>


