<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Top Header -->
<div class="container">
    <div class="row align-items-center">
        <!-- Logo -->
        <div class="col-md-3">
            <div class="logo-container">
                <img src="images/logo.png" alt="Vườn Cây Đà Nẵng">
                <div class="logo-text">
                    <h1>VUONCAYDANANG.COM</h1>
                    <small>Chuyên Mua Bán Cây Xanh</small>
                </div>
            </div>
        </div>

        <!-- Search Bar -->
        <div class="col-md-6">
            <div class="search-bar">
                <input type="text" placeholder="Bạn muốn tìm gì..." class="form-control">
                <button type="submit" class="btn">Tìm</button>
            </div>
        </div>

        <!-- Contact & Buttons -->
        <div class="col-md-3">
            <div class="header-contact">
                <div>Hotline:</div>
                <div class="hotline">0968 702 490</div>
            </div>
            <div class="header-buttons">
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-success">
                    <i class="fas fa-shopping-cart"></i> Giỏ hàng
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="btn-group">
                            <button type="button" class="btn btn-success dropdown-toggle" data-bs-toggle="dropdown">
                                <i class="fas fa-user"></i> ${sessionScope.user.fullName}
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard/profile">
                                    <i class="fas fa-user-circle"></i> Tài khoản của tôi</a></li>
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
</div>

<!-- Main Navigation -->
<nav class="navbar navbar-expand-lg main-nav mt-3">
    <div class="container">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">TRANG CHỦ</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        GIỚI THIỆU
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Về chúng tôi</a></li>
                        <li><a class="dropdown-item" href="#">Tầm nhìn & Sứ mệnh</a></li>
                        <li><a class="dropdown-item" href="#">Đội ngũ chuyên gia</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/plants">SẢN PHẨM</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">BÁO GIÁ</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        DỊCH VỤ
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#">Tư vấn thiết kế</a></li>
                        <li><a class="dropdown-item" href="#">Chăm sóc cây</a></li>
                        <li><a class="dropdown-item" href="#">Cho thuê cây</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">TIN TỨC</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">DỰ ÁN</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">LIÊN HỆ</a>
                </li>
            </ul>
        </div>
    </div>
</nav>