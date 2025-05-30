<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
<%
    model.User user = (model.User) session.getAttribute("user");
%>
<!DOCTYPE html>
    <html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Vườn Cây Hà Nội - Chuyên Mua Bán Cây Xanh</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <style>
            
            body {
    background-color: #171717; 
    }   
    .logo-bar {
  background-color: #28a745; /* Màu xanh Bootstrap chuẩn */
  color: white; /* Để chữ nổi trên nền xanh */
  border-radius: 5px; /* Tùy chọn: bo góc */
}     
        .logo-bar {
            background-color: #28a745; /* Màu xanh Bootstrap chuẩn */
            border-radius: 5px; /* Tùy chọn: bo góc */
            padding: 15px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            
        }
        .logo img {
    width: 150px;  /* tăng kích thước theo ý bạn */
    height: auto;  /* giữ tỉ lệ ảnh */
    margin-right: 15px; /* thêm khoảng cách bên phải nếu muốn */
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
    text-transform: uppercase; /* Viết hoa */
    color: red;                /* Màu đỏ */
    font-weight: bold;         /* (Tùy chọn) In đậm */
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
    color: #28a745; /* chữ trắng cho tiêu đề */
    }
    .sidebar ul.list-group li.list-group-item {
    background-color: #171717;
    border: none; /* bỏ viền */
    padding-left: 0; /* nếu muốn */
    }

    .sidebar ul.list-group li.list-group-item a {
    color: #28a745; /* xanh sáng */
    text-decoration: none; /* bỏ gạch chân */
    }
    .sidebar ul.list-group {
    padding: 0; /* bỏ padding mặc định */
    margin: 0; /* bỏ margin nếu có */
    }

    .sidebar ul.list-group li.list-group-item {
    border: 1px solid #28a745 !important;
    border-top: none; /* bỏ viền trên của các ô, trừ ô đầu */
    margin: 0; /* bỏ khoảng cách giữa các ô */
    border-radius: 0; /* bỏ bo góc */
    background-color:  !important;
    padding: 8px 12px;
    }

    /* Giữ viền trên cho ô đầu tiên */
    .sidebar ul.list-group li.list-group-item:first-child {
    border-top: 1px solid #28a745 !important;
    border-radius: 4px 4px 0 0; /* bo góc trên */
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
    .bold-text1{ 
        display: inline-block;          /* Giúp viền gọn sát chữ */
        border: 3px solid #28a745;       /* Viền xanh lá */
        padding: 2px 6px;                /* Khoảng cách giữa chữ và viền */
        border-radius: 4px;              /* Bo góc nhẹ */
        font-weight: bold;               /* In đậm (áp dụng chung cho cả 3) */
        margin: 5px 5px ;
    background-color: #f8f9fa;}

    .bold-text2{ 
        display: inline-block;          /* Giúp viền gọn sát chữ */
        border: 3px solid #28a745;       /* Viền xanh lá */
        padding: 2px 6px;                /* Khoảng cách giữa chữ và viền */
        border-radius: 4px;              /* Bo góc nhẹ */
        font-weight: bold;               /* In đậm (áp dụng chung cho cả 3) */
        margin: 5px 5px ;
    background-color: #f8f9fa;
    }
    .bold-text3 {
        display: inline-block;          /* Giúp viền gọn sát chữ */
        border: 3px solid #28a745;       /* Viền xanh lá */
        padding: 2px 6px;                /* Khoảng cách giữa chữ và viền */
        border-radius: 4px;              /* Bo góc nhẹ */
        font-weight: bold;               /* In đậm (áp dụng chung cho cả 3) */
        margin: 5px 5px ;                   /* Tạo khoảng cách dọc giữa các dòng */
        background-color: #f8f9fa;
    }
    .company-intro {
  background-color: #9ED2BB;
  padding: 30px;
  border-radius: 10px;
  margin-bottom: 40px;
  font-size: 1.25rem;      /* Làm chữ to hơn (20px) */
  line-height: 1.8;        /* Giãn dòng dễ đọc */
  text-align: justify;     /* Căn đều chữ cho đẹp */            /* Màu chữ dễ nhìn */
  margin-top: 15px;
  color: white;
}
.company-intro img {
  width: 100%;              /* Làm ảnh chiếm toàn bộ chiều ngang khung */
  height: auto;             /* Giữ tỉ lệ ảnh */
  object-fit: cover;        /* Cắt ảnh để lấp đầy khung mà không bị méo */
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
    background-color:#388e3c;
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
    <!-- Logo and Search -->
<div class="logo-bar">
    <div class="container d-flex align-items-center justify-content-between flex-wrap">
        <div class="d-flex align-items-center logo">
            <img src="images\logo.png" alt="Logo">
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
                        <li><a class="dropdown-item" href="viewProfile.jsp">Xem hồ sơ</a></li>
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
        <li class="nav-item"><a class="nav-link" href="#">TRANG CHỦ</a></li>

        <!-- Dropdown GIỚI THIỆU -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="gioithieuDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            GIỚI THIỆU
            </a>
            <ul class="dropdown-menu" aria-labelledby="gioithieuDropdown">
            <li><a class="dropdown-item" href="#">Cây cảnh</a></li>
            <li><a class="dropdown-item" href="#">Chuyên gia</a></li>
            </ul>
        </li>

        <li class="nav-item"><a class="nav-link" href="#">SẢN PHẨM</a></li>
        <li class="nav-item"><a class="nav-link" href="#">BÁO GIÁ</a></li>

        <!-- Dropdown DỊCH VỤ -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="dichvuDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            DỊCH VỤ
            </a>
            <ul class="dropdown-menu" aria-labelledby="dichvuDropdown">
            <li><a class="dropdown-item" href="#">Chăm sóc cây</a></li>
            </ul>
        </li>

        <li class="nav-item"><a class="nav-link" href="#">TIN TỨC</a></li>
        <li class="nav-item"><a class="nav-link" href="#">DỰ ÁN</a></li>
        <li class="nav-item"><a class="nav-link" href="#">LIÊN HỆ</a></li>
        </ul>
    </div>
    </nav>
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
                    <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="#banner   Carousel" data-bs-slide-to="0" class="active"></button>
                        <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="2"></button>   
                </div>
            </div>
        </div>

        <!-- Product Categories full width -->
        <section>
            <h3 class="text-success text-center">Danh mục sản phẩm</h3>
            <div class="row banner-categories text-center mt-4">
                <div class="col-md-3">
                    <img src="images\download.jpg" class="img-fluid rounded shadow-sm" alt="Cây Xanh Công Trình">
                    <p class="bold-text1">Cây xanh công trình</p><br>
                    <p class="bold-text2">Chi tiết</p><br>
                    <p class="bold-text3">Số lượng:</p><br>
                </div>
                <div class="col-md-3">
                    <img src="images\tải xuống.jpg" class="img-fluid rounded shadow-sm" alt="Cây Xanh Ngoại Thất">
                    <p class="bold-text1">Cây xanh công trình</p><br>
                    <p class="bold-text2">Chi tiết</p><br>
                    <p class="bold-text3">Số lượng:</p><br>
                </div>
                <div class="col-md-3">
                    <img src="images\noi that.jpg" class="img-fluid rounded shadow-sm" alt="Cây xanh nội thất">
                    <p class="bold-text1">Cây xanh nội thất</p><br>
                    <p class="bold-text2">Chi tiết</p><br>
                    <p class="bold-text3">Số lượng:</p><br>
                </div>
                <div class="col-md-3">
                    <img src="images\phong thuy.jpg" class="img-fluid rounded shadow-sm" alt="Cây phong thủy">
                    <p class="bold-text1">Cây phong thủy</p><br>
                    <p class="bold-text2">Chi tiết</p><br>
                    <p class="bold-text3">Số lượng:</p><br>
                </div>
            </div>
            <p class="banner-text">GIÁ RẺ - BỀN ĐẸP - GIAO NHANH</p>
        </section>
    </div>
<div class="container mt-4 company-intro">
  <h3>Giới thiệu về công ty</h3>
  <div class="row align-items-center">
    <div class="col-md-6">
      <p>
        Công ty chúng tôi là đơn vị hàng đầu trong lĩnh vực cung cấp các sản phẩm chất lượng cao,
        đáp ứng nhu cầu đa dạng của khách hàng. Với đội ngũ nhân viên chuyên nghiệp và tận tâm,
        chúng tôi cam kết mang lại trải nghiệm mua sắm tuyệt vời cùng với dịch vụ chăm sóc khách hàng tốt nhất.
      </p>
    </div>
    <div class="col-md-6">
      <img src="images\gioithieu.png" alt="Ảnh giới thiệu công ty" class="img-fluid rounded shadow">
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
        <p><strong>Giao hàng trên toàn quốc</strong><br>Tất cả giá trị của đơn hàng.</p>
      </div>
      <div class="col-md-3 col-sm-6 feature-box">
        <img src="images\exchange.png" alt="Đổi trả" class="feature-icon">
        <p><strong>Đổi trả miễn phí</strong><br>Trong vòng 7 ngày</p>
      </div>
      <div class="col-md-3 col-sm-6 feature-box">
        <img src=images\customer-service.png alt="Hotline" class="feature-icon">
        <p><strong>Hotline: 0968 702 490</strong><br>Hỗ trợ 24/7</p>
      </div>
      <div class="col-md-3 col-sm-6 feature-box">
        <img src="images\price.png" alt="Thanh toán" class="feature-icon">
        <p><strong>Thanh toán</strong><br>Bảo mật thanh toán</p>
      </div>
    </div>
  </div>
</section>

        </div>
    </div>
    <!-- Footer -->
    <footer>
    <div class="container">
        <h5>Thông tin liên hệ</h5>
        <p><i class="fa fa-map-marker-alt"></i> Địa chỉ: Số 123 Đường Nguyễn Văn Linh, Quận Hòa Hải, Đà Nẵng </p>
        <p><i class="fa fa-phone"></i> Hotline: 0949483982 </p>
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

