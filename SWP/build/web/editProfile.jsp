<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f4;
        }
        .form-container {
            max-width: 600px;
            margin: auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: left;
        }
        label {
            display: block;
            margin: 10px 0 5px;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            margin: 5px 0 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="file"] {
            padding: 3px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 4px;
            margin-top: 10px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        a {
            display: inline-block;
            margin-top: 10px;
            color: #4CAF50;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            margin: 10px 0;
        }
        .section-title {
            font-weight: bold;
            margin-top: 30px;
            font-size: 1.2em;
            border-bottom: 1px solid #ccc;
            padding-bottom: 5px;
        }
    </style>
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
