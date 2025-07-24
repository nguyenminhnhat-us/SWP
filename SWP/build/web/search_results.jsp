<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Plant" %>
<%
    List<Plant> plants = (List<Plant>) request.getAttribute("plants");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm - Vườn Cây Đà Nẵng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- CSS giao diện kết quả tìm kiếm -->
    <link rel="stylesheet" href="css/search-styles.css">
</head>
<body>

<div class="container my-5">
    <!-- BREADCRUMB -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb text-white">
            <li class="breadcrumb-item"><a href="index.jsp" class="text-decoration-none text-success">Trang chủ</a></li>
            <li class="breadcrumb-item active text-white" aria-current="page">Kết quả tìm kiếm</li>
        </ol>
    </nav>

    <h2 class="text-success text-center mb-5">Kết quả tìm kiếm</h2>

    <div class="row g-4">
        <% if (plants != null && !plants.isEmpty()) {
            for (Plant p : plants) { %>
                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                    <div class="card plant-card h-100">
                        <img src="<%= p.getImageUrl() %>" class="card-img-top" alt="<%= p.getName() %>">
                        <div class="card-body d-flex flex-column">
                            <h5 class="plant-title text-center"><%= p.getName() %></h5>
                            <p class="card-text small mt-2">Mô tả: <%= p.getDescription() %></p>
                            <p class="card-text small">Giá: <strong><%= p.getPrice() %> VNĐ</strong></p>
                            <p class="card-text small">Còn lại: <%= p.getStockQuantity() %> cây</p>
                        </div>
                        <div class="card-footer text-center bg-transparent border-0 pb-3">
                            <a href="plantDetailsServlet?plantId=<%= p.getPlantId() %>" class="btn btn-light text-dark w-75">Chi tiết</a>
                        </div>
                    </div>
                </div>
        <%  }
        } else { %>
            <div class="col-12">
                <div class="alert alert-warning text-center">
                    Không tìm thấy sản phẩm phù hợp với từ khóa bạn đã nhập.
                </div>
            </div>
        <% } %>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
