<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Plant" %>
<%
    Plant plant = (Plant) request.getAttribute("plant");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= plant.getName() %> | Chi tiết sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .product-detail-container {
            margin: 50px auto;
            max-width: 1000px;
            display: flex;
            gap: 30px;
        }
        .product-detail-container img {
            max-width: 450px;
            border-radius: 10px;
        }
        .product-info h2 {
            font-size: 28px;
            font-weight: bold;
        }
        .price {
            color: green;
            font-size: 22px;
            margin: 10px 0;
        }
        .desc {
            margin-top: 15px;
            font-size: 16px;
        }
        .btn-back {
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="product-detail-container">
        <div>
            <img src="<%= plant.getImageUrl() %>" alt="<%= plant.getName() %>">
        </div>
        <div class="product-info">
            <h2><%= plant.getName() %></h2>
            <div class="price">Giá: $<%= plant.getPrice() %></div>
            <p><strong>Số lượng còn lại:</strong> <%= plant.getStockQuantity() %></p>
            <div class="desc"><%= plant.getDescription() %></div>

            <form action="addToCart" method="post" class="mt-3">
                <input type="hidden" name="plantId" value="<%= plant.getPlantId() %>">
                <input type="number" name="quantity" value="1" min="1" max="<%= plant.getStockQuantity() %>" class="form-control mb-2" style="width: 100px;">
                <button type="submit" class="btn btn-success">Thêm vào giỏ hàng</button>
            </form>

            <a href="plantList" class="btn btn-secondary btn-back">← Quay lại danh sách</a>
        </div>
    </div>
</div>

</body>
</html>
