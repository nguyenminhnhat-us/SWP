<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <% model.User user=(model.User) session.getAttribute("user"); %>
              

                <!-- Bắt đầu phần header thực tế -->
                <header>
                    <div class="logo-bar">
                        <div class="container d-flex align-items-center justify-content-between flex-wrap">
                            <div class="d-flex align-items-center logo">
                                <img src="images/logo.png" alt="Logo">
                                <h1>VUONCAYDANANG.COM
                                    <small>Chuyên Mua Bán Cây Xanh</small>
                                </h1>
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
                                <a href="${pageContext.request.contextPath}/cart" class="btn btn-warning">GIỎ HÀNG </a>
                                <% if (user !=null) {%>
                                    <div class="dropdown">
                                        <button class="btn btn-outline-light bg-success text-white dropdown-toggle"
                                            data-bs-toggle="dropdown">
                                            <%= user.getFullName()%>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard/profile">Xem hồ sơ</a></li>
                                            <li><a class="dropdown-item" href="editProfile.jsp">Chỉnh sửa hồ sơ</a></li>
                                            <li><a class="dropdown-item" href="logout">Đăng xuất</a></li>
                                        </ul>
                                    </div>
                                    <% } else { %>
                                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light bg-success text-white">Đăng
                                            nhập</a>
                                        <% }%>
                            </div>
                        </div>
                    </div>
                    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
                        <div class="container">
                            <ul class="navbar-nav d-flex justify-content-around w-100">
                                <li class="nav-item"><a class="nav-link" href="#">TRANG CHỦ</a></li>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="gioithieuDropdown" role="button"
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                        GIỚI THIỆU
                                    </a>
                                    <ul class="dropdown-menu" aria-labelledby="gioithieuDropdown">
                                        <li><a class="dropdown-item" href="#">Cây cảnh</a></li>
                                        <li><a class="dropdown-item" href="#">Chuyên gia</a></li>
                                    </ul>
                                </li>
                                <li class="nav-item"><a class="nav-link" href="#">SẢN PHẨM</a></li>
                                <li class="nav-item"><a class="nav-link" href="#">BÁO GIÁ</a></li>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="dichvuDropdown" role="button"
                                        data-bs-toggle="dropdown" aria-expanded="false">
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
                </header>