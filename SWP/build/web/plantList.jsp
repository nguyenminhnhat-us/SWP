<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" import="java.util.*, model.Plant" %>
<%
    model.User user = (model.User) session.getAttribute("user");
    List<Plant> plants = (List<Plant>) request.getAttribute("plants");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh Mục Cây Cảnh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/index-style.css">
    <style>
        body { font-family: Arial, sans-serif; background-color: #000; color: #fff; margin: 0; padding: 0; }
        .product-list { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; padding: 20px; }
        .product-item { background-color: #006400; border: 2px solid #fff; width: 200px; text-align: center; padding: 10px; cursor: pointer; }
        .product-item img { max-width: 100%; height: auto; }
    </style>
</head>
<body>

<!-- Logo và tìm kiếm -->
<div class="logo-bar">
    <div class="container d-flex align-items-center justify-content-between flex-wrap">
        <div class="d-flex align-items-center logo">
            <img src="images/logo.png" alt="Logo">
            <h1>VUONCAYDANANG.COM<br><small>Chuyên Mua Bán Cây Xanh</small></h1>
        </div>
        <div class="input-group w-50">
            <input type="text" class="form-control" placeholder="Bạn muốn tìm gì...">
            <button class="btn btn-success">Tìm</button>
        </div>
        <div class="text-end">
            <p class="mb-0 hotline-label">Hotline:</p>
            <div class="hotline-number">0968 702 490</div>
        </div>
        <div class="d-flex gap-2 ms-auto">
            <button class="btn btn-warning">GIỎ HÀNG 🛒</button>
            <% if (user != null) { %>
                <div class="dropdown">
                    <button class="btn btn-outline-light bg-success text-white dropdown-toggle" data-bs-toggle="dropdown">
                        <%= user.getFullName() %>
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="viewProfile">Xem hồ sơ</a></li>
                        <li><a class="dropdown-item" href="editProfile.jsp">Chỉnh sửa hồ sơ</a></li>
                        <li><a class="dropdown-item" href="logout">Đăng xuất</a></li>
                    </ul>
                </div>
            <% } else { %>
                <a href="login.jsp" class="btn btn-outline-light bg-success text-white">Đăng nhập</a>
            <% } %>
        </div>
    </div>
</div>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container">
        <ul class="navbar-nav d-flex justify-content-around w-100">
            <li class="nav-item"><a class="nav-link" href="index.jsp">TRANG CHỦ</a></li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">GIỚI THIỆU</a>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#">Cây cảnh</a></li>
                    <li><a class="dropdown-item" href="#">Chuyên gia</a></li>
                </ul>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">SẢN PHẨM</a>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="plantList?category=1">Cây Xanh Công Trình</a></li>
                    <li><a class="dropdown-item" href="plantList?category=2">Cây Xanh Ngoại Thất</a></li>
                    <li><a class="dropdown-item" href="plantList?category=3">Cây Xanh Nội Thất</a></li>
                    <li><a class="dropdown-item" href="plantList?category=4">Cây Phong Thủy</a></li>
                    <li><a class="dropdown-item" href="plantList">Tất Cả Sản Phẩm</a></li>
                </ul>
            </li>
            <li class="nav-item"><a class="nav-link" href="#">BÁO GIÁ</a></li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">DỊCH VỤ</a>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#">Chăm sóc cây</a></li>
                </ul>
            </li>
            <li class="nav-item"><a class="nav-link" href="#">TIN TỨC</a></li>
            <li class="nav-item"><a class="nav-link" href="#">DỰ ÁN</a></li>
            <li class="nav-item"><a class="nav-link" href="#">LIÊN HỆ</a></li>
        </ul>
    </div>
</nav>

<!-- Danh sách sản phẩm -->
<div class="container my-4">
    <h2>Danh sách sản phẩm</h2>
    <div class="product-list">
        <%
            if (plants != null) {
                for (Plant plant : plants) {
        %>
            <div class="product-item">
                <img src="<%= plant.getImageUrl() %>" alt="<%= plant.getName() %>">
                <h3><%= plant.getName() %></h3>
                <p>Mô tả: <%= plant.getDescription() %></p>
                <p>Giá: $<%= plant.getPrice() %></p>
                <p>Số lượng: <%= plant.getStockQuantity() %></p>
                <div style="text-align: center; margin-top: 10px;">
                    <a href="plantDetailsServlet?plantId=<%= plant.getPlantId() %>" class="btn btn-light">Chi tiết</a>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <p>Không có sản phẩm nào để hiển thị.</p>
        <%
            }
        %>
    </div>
</div>


<!-- Footer -->
<footer>
    <div class="container">
        <h5>Thông tin liên hệ</h5>
        <p><i class="fa fa-map-marker-alt"></i> Địa chỉ: Số 123 Đường Nguyễn Văn Linh, Quận Hòa Hải, Đà Nẵng</p>
        <p><i class="fa fa-phone"></i> Hotline: 0949483982</p>
        <p><i class="fa fa-envelope"></i> Email: nguyensuminhnhat@gmail.com</p>
        <p><i class="fa fa-globe"></i> Website: <a href="http://vuoncaydanang.com" style="color: white; text-decoration: underline;">vuoncaydanang.com</a></p>
        <div class="mt-3">
            <a href="#" style="color: white; margin-right: 10px;"><i class="fab fa-facebook-f"></i> Facebook</a>
            <a href="#" style="color: white; margin-right: 10px;"><i class="fab fa-instagram"></i> Instagram</a>
            <a href="#" style="color: white;"><i class="fab fa-youtube"></i> YouTube</a>
        </div>
        <p class="mt-3 mb-0">© 2025 Vườn Cây Đà Nẵng. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
