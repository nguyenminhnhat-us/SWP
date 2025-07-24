<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Top Header -->
<div class="container py-3">
    <div class="row align-items-center">
        <!-- Logo -->
        <div class="col-md-3 d-flex align-items-center">
            <img src="${pageContext.request.contextPath}/images/logo.png" alt="Vườn Cây Đà Nẵng" style="height: 60px;">
            <div class="ms-2">
                <h5 class="mb-0">VUONCAYDANANG.COM</h5>
                <small>Chuyên Mua Bán Cây Xanh</small>
            </div>
        </div>

        <!-- Search Bar -->
        <div class="col-md-6">
            <form class="d-flex" action="${pageContext.request.contextPath}/search" method="get">
                <input type="text" name="query" class="form-control" placeholder="Bạn muốn tìm gì...">
                <button type="submit" class="btn btn-success ms-2">Tìm</button>
            </form>
        </div>

        <!-- Hotline + Giỏ hàng + User -->
        <div class="col-md-3 text-end">
            <div class="mb-2">
                <strong>Hotline:</strong> <span class="text-danger">0968 702 490</span>
            </div>
            <div class="d-inline-block me-2">
                <div class="dropdown">
                    <button class="btn btn-warning dropdown-toggle" data-bs-toggle="dropdown">
                        GIỎ HÀNG 🛒
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cart">Giỏ cây</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/care-cart">Giỏ dịch vụ</a></li>
                    </ul>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="btn-group">
                        <button type="button" class="btn btn-success dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> ${sessionScope.user.fullName}
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard/profile">
                                <i class="fas fa-user-circle"></i> Tài khoản</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                <i class="fas fa-shopping-bag"></i> Đơn hàng</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-success">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Main Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success">
    <div class="container">
        <a class="navbar-brand d-lg-none" href="${pageContext.request.contextPath}/home">Vườn Cây</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">TRANG CHỦ</a></li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">GIỚI THIỆU</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Về chúng tôi</a></li>
                        <li><a class="dropdown-item" href="#">Tầm nhìn & Sứ mệnh</a></li>
                        <li><a class="dropdown-item" href="#">Đội ngũ chuyên gia</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">SẢN PHẨM</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/plantList?category=1">Cây Công Trình</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/plantList?category=2">Ngoại Thất</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/plantList?category=3">Nội Thất</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/plantList?category=4">Phong Thủy</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/plantList">Tất cả</a></li>
                    </ul>
                </li>

                <li class="nav-item"><a class="nav-link" href="#">BÁO GIÁ</a></li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">DỊCH VỤ</a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/articles.jsp">Tư vấn chăm sóc</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/book-care.jsp">Chăm sóc cây</a></li>
                        <li><a class="dropdown-item" href="#">Cho thuê cây</a></li>
                    </ul>
                </li>

                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/articleList">TIN TỨC</a></li>
                <li class="nav-item"><a class="nav-link" href="#">DỰ ÁN</a></li>
                <li class="nav-item"><a class="nav-link" href="#">LIÊN HỆ</a></li>
                <li class="nav-item">
                    <a class="nav-link btn btn-warning text-dark ms-2" style="font-weight:bold;" href="${pageContext.request.contextPath}/chat/chatbox.jsp">
                        <i class="fas fa-comments"></i> Chat
                    </a>
                </li>
            </ul>
                
        </div>
    </div>
</nav>
