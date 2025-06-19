<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%
                model.User user = (model.User) session.getAttribute("user");
                // Chuyển hướng đến HomeController nếu danh sách cây chưa được tải
                if (request.getAttribute("plants") == null) {
                    request.getRequestDispatcher("/home").forward(request, response);
                    return;
                }
            %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <title>Vườn Cây Đà Nẵng - Chuyên Mua Bán Cây Xanh</title>
                    <meta name="viewport" content="width=device-width, initial-scale=1">

                    <!-- Bootstrap 5 -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Font Awesome -->
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

                    <style>
                        body {
                            background-color: #f8f9fa;
                        }

                        /* Header Styles */
                        .logo-container {
                            display: flex;
                            align-items: center;
                            padding: 10px 0;
                        }

                        .logo-container img {
                            width: 100px;
                            height: auto;
                            margin-right: 15px;
                        }

                        .logo-text {
                            color: #333;
                        }

                        .logo-text h1 {
                            font-size: 24px;
                            margin: 0;
                            color: #28a745;
                        }

                        .search-bar {
                            display: flex;
                            align-items: center;
                            margin: 10px 0;
                        }

                        .search-bar input {
                            flex: 1;
                            padding: 8px 15px;
                            border: 2px solid #28a745;
                            border-radius: 4px 0 0 4px;
                            outline: none;
                        }

                        .search-bar button {
                            padding: 8px 20px;
                            background: #28a745;
                            border: none;
                            color: white;
                            border-radius: 0 4px 4px 0;
                            cursor: pointer;
                        }

                        .header-contact {
                            text-align: right;
                            padding: 10px 0;
                        }

                        .hotline {
                            color: red;
                            font-weight: bold;
                            font-size: 18px;
                        }

                        .header-buttons {
                            text-align: right;
                        }

                        .header-buttons .btn {
                            margin-left: 10px;
                        }

                        /* Navigation */
                        .main-nav {
                            background-color: #28a745;
                            padding: 0;
                        }

                        .main-nav .nav-link {
                            color: white !important;
                            padding: 15px 20px;
                            font-weight: 500;
                            transition: all 0.3s ease;
                        }

                        .main-nav .nav-link:hover {
                            background-color: rgba(255, 255, 255, 0.1);
                            color: yellow !important;
                        }

                        .dropdown-menu {
                            border: none;
                            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                        }

                        .dropdown-item:hover {
                            background-color: #28a745;
                            color: white !important;
                        }

                        .navbar {
                            background-color: #28a745;
                        }

                        .navbar-brand {
                            color: white !important;
                            font-weight: bold;
                        }

                        .nav-link {
                            color: white !important;
                        }

                        .hero-section {
                            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('images/banner.jpg');
                            background-size: cover;
                            background-position: center;
                            color: white;
                            padding: 100px 0;
                            text-align: center;
                            margin-bottom: 40px;
                        }

                        .category-card {
                            border: none;
                            border-radius: 15px;
                            overflow: hidden;
                            transition: transform 0.3s;
                            margin-bottom: 30px;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        }

                        .category-card:hover {
                            transform: translateY(-5px);
                        }

                        .category-card img {
                            height: 200px;
                            object-fit: cover;
                        }

                        .product-card {
                            border: none;
                            border-radius: 15px;
                            overflow: hidden;
                            transition: transform 0.3s;
                            margin-bottom: 30px;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                        }

                        .product-card:hover {
                            transform: translateY(-5px);
                        }

                        .product-card img {
                            height: 250px;
                            object-fit: cover;
                        }

                        .price {
                            color: #28a745;
                            font-weight: bold;
                            font-size: 1.2rem;
                        }

                        .features-section {
                            background-color: #28a745;
                            color: white;
                            padding: 60px 0;
                            margin: 40px 0;
                        }

                        .feature-item {
                            text-align: center;
                            padding: 20px;
                        }

                        .feature-item i {
                            font-size: 3rem;
                            margin-bottom: 20px;
                        }

                        footer {
                            background-color: #333;
                            color: white;
                            padding: 40px 0;
                        }

                        .social-links a {
                            color: white;
                            margin-right: 15px;
                            font-size: 1.5rem;
                        }

                        .btn-success {
                            background-color: #28a745;
                            border-color: #28a745;
                        }

                        .btn-outline-success {
                            color: #28a745;
                            border-color: #28a745;
                        }
                    </style>

                </head>

                <body>
                    <jsp:include page="./common/home/header.jsp"></jsp:include>

                    <!-- Hero Section -->
                    <section class="hero-section">
                        <div class="container">
                            <h1 class="display-4">Chào mừng đến với Vườn Cây Đà Nẵng</h1>
                            <p class="lead">Nơi cung cấp các loại cây xanh chất lượng cao cho không gian của bạn</p>
                            <a href="#products" class="btn btn-success btn-lg">Xem sản phẩm</a>
                        </div>
                    </section>

                    <!-- Categories Section -->
                    <section class="container mb-5">
                        <h2 class="text-center mb-4">Danh mục sản phẩm</h2>
                        <div class="d-flex align-items-center mb-3">
                            <button class="btn btn-outline-success me-2" id="category-prev"><i class="fas fa-chevron-left"></i></button>
                            <div id="category-list" class="flex-grow-1 d-flex justify-content-center">
                                <c:forEach var="cat" items="${categories}">
                                    <span class="badge bg-success mx-2">${cat.name}</span>
                                </c:forEach>
                            </div>
                            <button class="btn btn-outline-success ms-2" id="category-next"><i class="fas fa-chevron-right"></i></button>
                        </div>
                    </section>

                    <!-- Featured Products Section -->
                    <section id="products" class="container mb-5">
                        <h2 class="text-center mb-4">Sản phẩm nổi bật</h2>
                        <div class="row">
                            <c:forEach var="plant" items="${plants}">
                                <div class="col-md-3">
                                    <div class="product-card card">
                                        <img src="${plant.imageUrl}" class="card-img-top" alt="${plant.name}">
                                        <div class="card-body">
                                            <h5 class="card-title">${plant.name}</h5>
                                            <p class="card-text">${plant.description}</p>
                                            <p class="price">
                                                <fmt:formatNumber value="${plant.price}" type="currency"
                                                    currencySymbol="₫" />
                                            </p>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <a href="plant-details?id=${plant.plantId}"
                                                    class="btn btn-outline-success">Chi tiết</a>
                                                <form action="${pageContext.request.contextPath}/cart" method="post"
                                                    class="d-inline">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="plantId" value="${plant.plantId}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>

                    <!-- Features Section -->
                    <section class="features-section">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="feature-item">
                                        <i class="fas fa-truck"></i>
                                        <h4>Giao hàng toàn quốc</h4>
                                        <p>Miễn phí giao hàng cho đơn từ 1 triệu</p>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="feature-item">
                                        <i class="fas fa-leaf"></i>
                                        <h4>Sản phẩm chất lượng</h4>
                                        <p>Cam kết cây khỏe mạnh 100%</p>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="feature-item">
                                        <i class="fas fa-sync-alt"></i>
                                        <h4>Đổi trả dễ dàng</h4>
                                        <p>Đổi trả trong vòng 7 ngày</p>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="feature-item">
                                        <i class="fas fa-headset"></i>
                                        <h4>Hỗ trợ 24/7</h4>
                                        <p>Tư vấn chuyên nghiệp</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <nav>
                        <ul class="pagination justify-content-center">
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>

                    <jsp:include page="./common/home/footer.jsp"></jsp:include>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        // JS để chuyển danh mục (ẩn/hiện, hoặc scroll)
                    </script>
                </body>

                </html>