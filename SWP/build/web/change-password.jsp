<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <style>
        .message { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <h2>Change Password</h2>

    <% if (request.getAttribute("message") != null) { %>
        <p class="message"><%= request.getAttribute("message") %></p>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="ChangePasswordServlet" method="post">
        <label for="currentPassword">Current Password:</label><br>
        <input type="password" id="currentPassword" name="currentPassword" required><br><br>

        <label for="newPassword">New Password:</label><br>
        <input type="password" id="newPassword" name="newPassword" required><br><br>

        <label for="confirmPassword">Confirm New Password:</label><br>
        <input type="password" id="confirmPassword" name="confirmPassword" required><br><br>

        <input type="submit" value="Change Password">
    </form>

    <a href="profile">Back to Profile</a>
</body>
</html>
