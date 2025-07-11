<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/login-style.css">
</head>
<body>
    <div class="container">
        <h2 class="mt-5">Change Password</h2>

        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="ChangePasswordServlet" method="post" class="mt-4">
            <div class="mb-3">
                <label for="currentPassword" class="form-label">Current Password:</label>
                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="newPassword" class="form-label">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm New Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-primary">Change Password</button>
        </form>

        <a href="profile" class="btn btn-link mt-3">Back to Profile</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
