<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    .sidebar-custom {
        background-color: #23272b;
        color: #fff;
        min-height: 100vh;
        height: 100%;
        padding: 0;
        border-right: 1px solid #28a745;
    }
    .sidebar-custom .nav-link {
        color: #b8c7ce;
        border-radius: 0;
        padding: 15px 20px;
        font-size: 1.05rem;
        transition: background 0.2s, color 0.2s;
    }
    .sidebar-custom .nav-link.active, .sidebar-custom .nav-link:hover {
        background-color: #28a745;
        color: #fff !important;
    }
    .sidebar-custom .nav-link i {
        width: 22px;
        text-align: center;
    }
    .sidebar-custom .dropdown-toggle, .sidebar-custom .dropdown-item {
        color: #b8c7ce;
    }
    .sidebar-custom .dropdown-menu {
        background: #23272b;
        border: none;
    }
    .sidebar-custom .dropdown-item:hover {
        background: #28a745;
        color: #fff;
    }
    .sidebar-custom .fs-4 {
        color: #28a745;
        font-weight: bold;
    }
</style>
<div class="sidebar-custom d-flex flex-column flex-shrink-0 p-0">
    <div class="p-3">
        <a href="${pageContext.request.contextPath}/dashboard/dashboard.jsp" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-light text-decoration-none">
            <span class="fs-4"><i class="fa fa-leaf text-success"></i> Dashboard</span>
        </a>
    </div>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link active" aria-current="page">
                <i class="fa fa-home me-2"></i> Trang chủ
            </a>
        </li>
        
<!-- Menu chỉ dành cho Admin -->
<c:if test="${sessionScope.user.role == 'admin'}">
    <li>
        <a href="${pageContext.request.contextPath}/dashboard/manage-users" class="nav-link">
            <i class="fa fa-users me-2"></i> Quản lý người dùng
        </a>
    </li>
    <li>
        <a href="${pageContext.request.contextPath}/dashboard/manage-plants" class="nav-link">
            <i class="fa fa-seedling me-2"></i> Quản lý cây
        </a>
    </li>
    <li>
        <a href="${pageContext.request.contextPath}/dashboard/manage-categories" class="nav-link">
            <i class="fa fa-tags me-2"></i> Quản lý phân loại cây
        </a>
    </li>
    <li>
        <a href="${pageContext.request.contextPath}/dashboard/care-services" class="nav-link">
            <i class="fa fa-leaf me-2"></i> Care Packages: Edit Care Services
        </a>
    </li>
    <li>
        <a href="${pageContext.request.contextPath}/dashboard/reports" class="nav-link">
            <i class="fa fa-chart-line me-2"></i> Báo cáo
        </a>
    </li>
</c:if>

<!-- Menu chỉ dành cho Expert -->
<c:if test="${sessionScope.user.role == 'expert'}">
    <li>
<a href="${pageContext.request.contextPath}/care-orders" class="nav-link">
    <i class="fa fa-tasks me-2"></i> Quản lý cây đang chăm sóc
</a>
    </li>
    <li>
    <a href="${pageContext.request.contextPath}/expert-schedule" class="nav-link">
        <i class="fa fa-calendar-check me-2"></i> Lịch chăm sóc cây
    </a>
</li>
        <a href="${pageContext.request.contextPath}/write-article.jsp" class="nav-link">
            <i class="fa fa-book me-2"></i> Viết bài tư vấn
        </a>
    </li>
    <li>
        <a href="${pageContext.request.contextPath}/logout.jsp" class="nav-link">
            <i class="fa fa-sign-out-alt me-2"></i> Đăng xuất
        </a>
    </li>
</c:if>

        
        <!-- Menu cho tất cả các role -->
        <li>
            <a href="${pageContext.request.contextPath}/dashboard/order-history" class="nav-link">
                <i class="fa fa-shopping-cart me-2"></i> Quản lý đơn hàng
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/dashboard/profile" class="nav-link">
                <i class="fa fa-user me-2"></i> Profile
            </a>
        </li>
    </ul>
    <div class="mt-auto p-3">
        <div class="dropdown">
            <a href="#" class="d-flex align-items-center link-light text-decoration-none dropdown-toggle" id="dropdownUser2" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="/images/logo.png" alt="" width="32" height="32" class="rounded-circle me-2">
                <strong>
<c:choose>
    <c:when test="${sessionScope.user.role == 'admin'}">Admin</c:when>
    <c:when test="${sessionScope.user.role == 'staff'}">Nhân viên</c:when>
    <c:when test="${sessionScope.user.role == 'expert'}">Chuyên gia</c:when>
    <c:otherwise>Người dùng</c:otherwise>
</c:choose>
                </strong>
            </a>
            <ul class="dropdown-menu text-small shadow" aria-labelledby="dropdownUser2">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/viewProfile">Hồ sơ</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
            </ul>
        </div>
    </div>
</div>
