<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header-style.css">
</head>
<body>
    <div class="form-container">
        <h2>Edit Profile</h2>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="profile" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="edit">
            
            <!-- Thông tin cá nhân -->
            <label for="fullName">Full Name:</label>
            <input type="text" id="fullName" name="fullName" value="${user.fullName}" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="${user.email}" required>

            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" value="${user.phone}" required>

            <label for="address">Address:</label>
            <textarea id="address" name="address" required>${user.address}</textarea>

            <label for="avatar">Avatar:</label>
            <input type="file" id="avatar" name="avatar" accept="image/*">

            <!-- ... phần form Edit Profile như cũ ... -->

<input type="submit" value="Save Changes">

<!-- Nút chuyển sang trang đổi mật khẩu -->
<p style="text-align:center; margin-top:20px;">
    <a href="change-password.jsp" style="color:#4CAF50; font-weight:bold; text-decoration:none; border:1px solid #4CAF50; padding:8px 16px; border-radius:4px;">Change Password</a>
</p>

        </form>
        <a href="profile">Back to Profile</a>
    </div>
</body>
</html>
