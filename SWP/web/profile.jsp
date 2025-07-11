<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>

<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        user = (User) session.getAttribute("user");
    }
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = user.getFullName();
    String avatarPath = (user.getAvatarPath() != null && !user.getAvatarPath().isEmpty())
        ? (request.getContextPath() + "/images/" + user.getAvatarPath())
        : (request.getContextPath() + "/images/banner 3.jpg");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header-style.css">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const imageUpload = document.getElementById('imageUpload');
            const profileImage = document.getElementById('profileImage');

            imageUpload.addEventListener('change', function (event) {
                const file = event.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        profileImage.src = e.target.result;
                    }
                    reader.readAsDataURL(file);
                }
            });
        });
    </script>
</head>
<body>
    <img src="<%=avatarPath%>" alt="Avatar" width="120" style="border-radius:50%;border:2px solid #28a745;">
    <h1>Hồ sơ cá nhân</h1>
    <p>Tên người dùng: <strong><%= username %></strong></p>

    <form action="change-password.jsp" method="get">
        <button type="submit">Đổi mật khẩu</button>
    </form>

    <form action="${pageContext.request.contextPath}/dashboard/profile" method="post" enctype="multipart/form-data" class="mt-2">
        <input type="hidden" name="action" value="upload_avatar">
        <input type="file" id="imageUpload" name="avatar" accept="image/*" required class="form-control form-control-sm mb-2">
        <button type="submit" class="btn btn-success btn-sm">Tải ảnh lên</button>
    </form>
</body>
</html>
