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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header-style.css">
</head>
<body>

<jsp:include page="/common/home/header.jsp" />

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
