<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String referrer = request.getHeader("referer");
    if (referrer != null) {
        session.setAttribute("redirectBack", referrer);
    }
%>

<form action="login" method="post">
    <label>Email:</label><br/>
    <input type="email" name="email" required/><br/>
    <label>Mật khẩu:</label><br/>
    <input type="password" name="password" required/><br/>
    <input type="submit" value="Đăng nhập"/>
</form>
<p style="color:red;">
    <%= request.getAttribute("errorMsg") != null ? request.getAttribute("errorMsg") : "" %>
</p>

