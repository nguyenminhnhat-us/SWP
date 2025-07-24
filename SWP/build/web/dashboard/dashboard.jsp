<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


            <!DOCTYPE html>
            <html lang="vi/en">

            <head>
                <meta charset="UTF-8">
                <title>Vườn Cây Đà Nẵng - Chuyên Mua Bán Cây Xanh</title>
                <meta name="viewport" content="width=device-width, initial-scale=1">

                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header-style.css">
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

                <jsp:include page="../common/home/header.jsp" />
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-2 p-0">
                            <jsp:include page="../common/dashboard/sidebar.jsp" />
                        </div>
                        <div class="col-md-10 p-4" style="background-color: #f8f9fa; min-height: 100vh;">
                            <h2>Chào mừng đến với trang quản trị!</h2>
                            <p>Đây là dashboard quản trị hệ thống Vườn Cây Đà Nẵng.</p>
                            <!-- Thêm nội dung dashboard tại đây -->
                        </div>
                    </div>
                </div>
                <jsp:include page="../common/home/footer.jsp" />


                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>