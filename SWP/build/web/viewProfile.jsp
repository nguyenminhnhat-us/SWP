<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header-style.css">
</head>
<body>
    <div class="profile-container">
        <h2>User Profile</h2>
        <img src="${pageContext.request.contextPath}/${user.avatarPath}" alt="Avatar" />
        <p><strong>Full Name:</strong> ${user.fullName}</p>
        <p><strong>Email:</strong> ${user.email}</p>
        <p><strong>Phone:</strong> ${user.phone}</p>
        <p><strong>Address:</strong> ${user.address}</p>
        <a href="editProfile.jsp">Chỉnh sửa hồ sơ</a>
        <a href="index.jsp" class="btn btn-secondary">Trang chủ</a>
    </div>
</body>
</html>
