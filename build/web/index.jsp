<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <% model.User user=(model.User) session.getAttribute("user"); // Chuyển hướng đến PlantServlet nếu danh sách
                cây chưa được tải if (request.getAttribute("plants")==null) {
                request.getRequestDispatcher("/plants").forward(request, response); return; } %>
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
                            background-color: #171717;
                        }

                        .logo-bar {
                            background-color: #28a745;
                            /* Màu xanh Bootstrap chuẩn */
                            color: white;
                            /* Để chữ nổi trên nền xanh */
                            border-radius: 5px;
                            /* Tùy chọn: bo góc */
                        }

                        .logo-bar {
                            background-color: #28a745;
                            /* Màu xanh Bootstrap chuẩn */
                            border-radius: 5px;
                            /* Tùy chọn: bo góc */
                            padding: 15px;
                            display: flex;
                            flex-wrap: wrap;
                            align-items: center;
                            justify-content: space-between;

                        }

                        .logo img {
                            width: 150px;
                            /* tăng kích thước theo ý bạn */
                            height: auto;
                            /* giữ tỉ lệ ảnh */
                            margin-right: 15px;
                            /* thêm khoảng cách bên phải nếu muốn */
                        }

                        .logo h1 {
                            font-size: 24px;
                            margin: 0;
                            color: #2e7d32;
                        }

                        .logo small {
                            font-size: 14px;
                            color: gray;
                        }

                        .hotline-label {
                            text-transform: uppercase;
                            /* Viết hoa */
                            color: red;
                            /* Màu đỏ */
                            font-weight: bold;
                            /* (Tùy chọn) In đậm */
                        }

                        .hotline-number {
                            color: red;
                            font-weight: bold;
                            font-size: 18px;
                        }

                        .nav-link:hover,
                        .dropdown-item:hover {
                            color: yellow !important;
                        }

                        .sidebar {
                            background-color: #171717;
                            padding: 15px;
                            color: #28a745;
                            /* chữ trắng cho tiêu đề */
                        }

                        .sidebar ul.list-group li.list-group-item {
                            background-color: #171717;
                            border: none;
                            /* bỏ viền */
                            padding-left: 0;
                            /* nếu muốn */
                        }

                        .sidebar ul.list-group li.list-group-item a {
                            color: #28a745;
                            /* xanh sáng */
                            text-decoration: none;
                            /* bỏ gạch chân */
                        }

                        .sidebar ul.list-group {
                            padding: 0;
                            /* bỏ padding mặc định */
                            margin: 0;
                            /* bỏ margin nếu có */
                        }

                        .sidebar ul.list-group li.list-group-item {
                            border: 1px solid #28a745 !important;
                            border-top: none;
                            /* bỏ viền trên của các ô, trừ ô đầu */
                            margin: 0;
                            /* bỏ khoảng cách giữa các ô */
                            border-radius: 0;
                            /* bỏ bo góc */
                            background-color: !important;
                            padding: 8px 12px;
                        }

                        /* Giữ viền trên cho ô đầu tiên */
                        .sidebar ul.list-group li.list-group-item:first-child {
                            border-top: 1px solid #28a745 !important;
                            border-radius: 4px 4px 0 0;
                            /* bo góc trên */
                        }

                        /* Bo góc dưới cho ô cuối */
                        .sidebar ul.list-group li.list-group-item:last-child {
                            border-radius: 0 0 4px 4px;
                        }

                        .sidebar ul.list-group li.list-group-item a:hover {
                            text-decoration: underline;
                        }

                        .banner-categories {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 20px;
                        }

                        .banner-categories .col-md-3 {
                            flex: 0 0 calc(25% - 20px);
                            box-sizing: border-box;
                            border: 3px solid #28a745;
                            padding: 2px;
                            border-radius: 10px;
                            transition: box-shadow 0.3s ease;
                            cursor: pointer;
                            background-color: #9ED2BB;
                        }

                        .banner-categories img {
                            width: 100%;
                            height: 250px;
                            object-fit: cover;
                        }

                        .banner-text {
                            font-weight: bold;
                            text-align: center;
                            margin-top: 20px;
                            color: #388e3c;
                            font-size: 20px;
                        }

                        .carousel-inner img {
                            width: 100%;
                            height: 450px;
                            object-fit: cover;
                            border-radius: 8px;
                        }

                        .bold-text1 {
                            display: inline-block;
                            /* Giúp viền gọn sát chữ */
                            border: 3px solid #28a745;
                            /* Viền xanh lá */
                            padding: 2px 6px;
                            /* Khoảng cách giữa chữ và viền */
                            border-radius: 4px;
                            /* Bo góc nhẹ */
                            font-weight: bold;
                            /* In đậm (áp dụng chung cho cả 3) */
                            margin: 5px 5px;
                            background-color: #f8f9fa;
                        }

                        .bold-text2 {
                            display: inline-block;
                            /* Giúp viền gọn sát chữ */
                            border: 3px solid #28a745;
                            /* Viền xanh lá */
                            padding: 2px 6px;
                            /* Khoảng cách giữa chữ và viền */
                            border-radius: 4px;
                            /* Bo góc nhẹ */
                            font-weight: bold;
                            /* In đậm (áp dụng chung cho cả 3) */
                            margin: 5px 5px;
                            background-color: #f8f9fa;
                        }

                        .bold-text3 {
                            display: inline-block;
                            /* Giúp viền gọn sát chữ */
                            border: 3px solid #28a745;
                            /* Viền xanh lá */
                            padding: 2px 6px;
                            /* Khoảng cách giữa chữ và viền */
                            border-radius: 4px;
                            /* Bo góc nhẹ */
                            font-weight: bold;
                            /* In đậm (áp dụng chung cho cả 3) */
                            margin: 5px 5px;
                            /* Tạo khoảng cách dọc giữa các dòng */
                            background-color: #f8f9fa;
                        }

                        .company-intro {
                            background-color: #9ED2BB;
                            padding: 30px;
                            border-radius: 10px;
                            margin-bottom: 40px;
                            font-size: 1.25rem;
                            /* Làm chữ to hơn (20px) */
                            line-height: 1.8;
                            /* Giãn dòng dễ đọc */
                            text-align: justify;
                            /* Căn đều chữ cho đẹp */
                            /* Màu chữ dễ nhìn */
                            margin-top: 15px;
                            color: white;
                        }

                        .company-intro img {
                            width: 100%;
                            /* Làm ảnh chiếm toàn bộ chiều ngang khung */
                            height: auto;
                            /* Giữ tỉ lệ ảnh */
                            object-fit: cover;
                            /* Cắt ảnh để lấp đầy khung mà không bị méo */
                            border-radius: 10px;
                            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
                            transition: transform 0.3s ease;
                        }

                        .commitment-section {
                            background-color: #171717;
                            color: white;
                            padding: 60px 20px;
                            margin-top: 40px;
                        }

                        .commitment-title {
                            font-size: 2.2rem;
                            font-weight: bold;
                            margin-bottom: 10px;
                        }

                        .commitment-subtitle {
                            font-size: 1.2rem;
                            margin-bottom: 40px;
                        }

                        .commitment-features {
                            display: flex;
                            flex-wrap: wrap;
                            justify-content: center;
                            gap: 30px;
                        }

                        .feature-box {
                            text-align: center;
                            flex: 1 1 200px;
                        }

                        .feature-icon {
                            width: 60px;
                            margin-bottom: 15px;
                        }

                        footer {
                            background-color: #388e3c;
                            color: white;
                            padding: 20px 0;
                        }

                        footer .container {
                            text-align: left;
                        }

                        footer a {
                            color: white;
                            text-decoration: none;
                        }

                        footer a:hover {
                            text-decoration: underline;
                        }
                    </style>

                </head>

                <body>
                    <!-- Modal Đăng nhập -->

                    </div>
                    <jsp:include page="./common/home/header.jsp"></jsp:include>

                    <!-- Main content -->
                    <div class="container my-4">
                        <div class="row">
                            <!-- Sidebar -->
                            <aside class="col-md-3 sidebar">
                                <h5>Danh mục sản phẩm</h5>
                                <ul class="list-group">
                                    <li class="list-group-item"><a href="#">Cây Xanh Công Trình</a></li>
                                    <li class="list-group-item"><a href="#">Cây Xanh Ngoại Thất</a></li>
                                    <li class="list-group-item"><a href="#">Cây Xanh Nội Thất</a></li>
                                    <li class="list-group-item"><a href="#">Cây Phong Thủy</a></li>
                                </ul>
                            </aside>

                            <!-- Carousel Banner -->
                            <div class="col-md-9">
                                <div id="bannerCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
                                    <div class="carousel-inner">
                                        <div class="carousel-item active">
                                            <img src="images\banner.jpg" class="d-block w-100" alt="Cây xanh 1">
                                        </div>
                                        <div class="carousel-item">
                                            <img src="images\banner2.jpg" class="d-block w-100" alt="Cây xanh 2">
                                        </div>
                                        <div class="carousel-item">
                                            <img src="images\banner 3.jpg" class="d-block w-100" alt="Cây xanh 3">
                                        </div>
                                    </div>
                                    <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel"
                                        data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel"
                                        data-bs-slide="next">
                                        <span class="carousel-control-next-icon"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                    <div class="carousel-indicators">
                                        <button type="button" data-bs-target="#banner   Carousel" data-bs-slide-to="0"
                                            class="active"></button>
                                        <button type="button" data-bs-target="#bannerCarousel"
                                            data-bs-slide-to="1"></button>
                                        <button type="button" data-bs-target="#bannerCarousel"
                                            data-bs-slide-to="2"></button>
                                    </div>
                                </div>
                            </div>

                            <!-- Product Categories full width -->
                            <section>
                                <h3 class="text-success text-center">Danh mục sản phẩm</h3>
                                <div class="row banner-categories text-center mt-4">
                                    <c:forEach var="plant" items="${plants}">
                                        <div class="col-md-3">
                                            <img src="${plant.imageUrl}" class="img-fluid rounded shadow-sm"
                                                alt="${plant.name}">
                                            <p class="bold-text1">${plant.name}</p>

                                            <p class="bold-text2">Giá:
                                                <fmt:formatNumber value="${plant.price}" type="currency"
                                                    currencySymbol="₫" />
                                            </p>

                                            <form action="${pageContext.request.contextPath}/cart" method="post"
                                                class="d-inline">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="plantId" value="${plant.plantId}">
                                                <input type="number" name="quantity" value="1" min="1"
                                                    max="${plant.stockQuantity}" class="form-control d-inline-block"
                                                    style="width: 80px;">
                                                <button type="submit" class="btn btn-success btn-sm">Thêm vào
                                                    giỏ</button>
                                            </form>
                                            <p><a href="#" class="btn btn-primary btn-sm">Chi tiết</a></p>
                                            <p>Số lượng: ${plant.stockQuantity}</p>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty plants}">
                                        <div class="alert alert-warning text-center">Không có sản phẩm để hiển thị.
                                        </div>
                                    </c:if>
                                </div>
                                <p class="banner-text">GIÁ RẺ - BỀN ĐẸP - GIAO NHANH</p>
                            </section>
                        </div>
                        <div class="container mt-4 company-intro">
                            <h3>Giới thiệu về công ty</h3>
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <p>
                                        Công ty chúng tôi là đơn vị hàng đầu trong lĩnh vực cung cấp các sản phẩm chất
                                        lượng cao,
                                        đáp ứng nhu cầu đa dạng của khách hàng. Với đội ngũ nhân viên chuyên nghiệp và
                                        tận tâm,
                                        chúng tôi cam kết mang lại trải nghiệm mua sắm tuyệt vời cùng với dịch vụ chăm
                                        sóc khách hàng tốt nhất.
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <img src="images\gioithieu.png" alt="Ảnh giới thiệu công ty"
                                        class="img-fluid rounded shadow">
                                </div>
                            </div>
                        </div>
                        <section class="commitment-section">
                            <div class="container text-center">
                                <h2 class="commitment-title">CAM KẾT TỪ VƯỜN CÂY ĐÀ Nẵng</h2>
                                <p class="commitment-subtitle">Công Ty Vườn Cây Đà Nẵng – Chuyên mua bán cây xanh</p>
                                <div class="row commitment-features">
                                    <div class="col-md-3 col-sm-6 feature-box">
                                        <img src="images\truck.png" alt="Giao hàng" class="feature-icon">
                                        <p><strong>Giao hàng trên toàn quốc</strong>
                                            Tất cả giá trị của đơn hàng.</p>
                                    </div>
                                    <div class="col-md-3 col-sm-6 feature-box">
                                        <img src="images\exchange.png" alt="Đổi trả" class="feature-icon">
                                        <p><strong>Đổi trả miễn phí</strong>
                                            Trong vòng 7 ngày</p>
                                    </div>
                                    <div class="col-md-3 col-sm-6 feature-box">
                                        <img src=images\customer-service.png alt="Hotline" class="feature-icon">
                                        <p><strong>Hotline: 0968 702 490</strong>
                                            Hỗ trợ 24/7</p>
                                    </div>
                                    <div class="col-md-3 col-sm-6 feature-box">
                                        <img src="images\price.png" alt="Thanh toán" class="feature-icon">
                                        <p><strong>Thanh toán</strong>
                                            Bảo mật thanh toán</p>
                                    </div>
                                </div>
                            </div>
                        </section>

                    </div>
                    </div>
                    <!-- Footer -->
                    <jsp:include page="./common/home/footer.jsp"></jsp:include>


                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>