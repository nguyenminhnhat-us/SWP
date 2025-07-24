<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Hoàn tất đăng ký</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login-style.css">
</head>
<body>
    <div class="login-wrapper">
        <div class="login-box">
            <h2>Hoàn tất đăng ký tài khoản</h2>

            <form action="${pageContext.request.contextPath}/completeRegistration" method="post">
                <label class="form-label" for="email">Email:</label><br>
                <input type="email" id="email" name="email" value="<%= session.getAttribute("email") %>" readonly class="form-control"><br>

                <label class="form-label" for="password">Mật khẩu:</label><br>
                <input type="password" id="password" name="password" required minlength="6" class="form-control"><br>

                <label class="form-label" for="fullName">Họ và tên:</label><br>
                <input type="text" id="fullName" name="fullName" required class="form-control"><br>

                <label class="form-label" for="phone">Điện thoại:</label><br>
                <input type="text" id="phone" name="phone" class="form-control"><br>

                <label class="form-label" for="address">Địa chỉ:</label><br>
                <input type="text" id="address" name="address" class="form-control"><br>

                <button type="submit" class="btn btn-success">Hoàn tất đăng ký</button>
            </form>

            <% String msg = (String) request.getAttribute("message");
               if(msg != null) { %>
               <p class="alert alert-danger" style="margin-top:15px;"><%= msg %></p>
            <% } %>
        </div>
    </div>
</body>
</html>
