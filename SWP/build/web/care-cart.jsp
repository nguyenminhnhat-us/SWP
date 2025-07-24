<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ page import="model.*" %>
<%@ page import="dal.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    CareCartDAO cartDAO = new CareCartDAO();
    UserDAO userDAO = new UserDAO();
    List<CareCart> careCarts = cartDAO.getAllCareCartsByUserId(user.getUserId());
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ dịch vụ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-center">🛒 Giỏ dịch vụ chăm sóc cây</h2>

    <!-- ✅ THÔNG BÁO -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div id="alertBox" class="alert alert-success alert-dismissible fade show" role="alert">
            ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div id="alertBox" class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <%
        if (careCarts == null || careCarts.isEmpty()) {
    %>
        <div class="alert alert-info mt-4">Chưa có đơn dịch vụ nào trong giỏ hàng.</div>
        <a href="book-care.jsp" class="btn btn-primary mt-2">➕ Thêm đơn chăm sóc</a>
    <%
        } else {
            for (CareCart cart : careCarts) {
                List<CareService> services = cartDAO.getServicesByCartId(cart.getCartId());
                User expert = userDAO.getUserById(cart.getExpertId());

                String status = cart.getStatus();
                String badgeClass = "bg-warning text-dark";
                String statusText = "Chờ duyệt";
                if ("approved".equals(status)) {
                    badgeClass = "bg-success";
                    statusText = "Đã duyệt";
                } else if ("rejected".equals(status)) {
                    badgeClass = "bg-danger";
                    statusText = "Bị từ chối";
                } else if ("in_progress".equals(status)) {
                    badgeClass = "bg-primary";
                    statusText = "Đang chăm sóc";
                } else if ("completed".equals(status)) {
                    badgeClass = "bg-secondary";
                    statusText = "Hoàn thành";
                }
    %>

        <div class="card mb-4 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">🌿 Cây: <%= cart.getPlantName() %></h5>
                <p>📅 Ngày giao cây: <%= cart.getDropOffDate() %></p>
                <p>🕑 Giờ hẹn: <%= cart.getAppointmentTime() %></p>
                <p>📍 Hình thức: <%= cart.getLocationType().equals("at_home") ? "Tại nhà" : "Tại cửa hàng" %></p>
                <% if ("at_home".equals(cart.getLocationType())) { %>
                    <p>🏠 Địa chỉ: <%= cart.getHomeAddress() %></p>
                <% } %>
                <p>🧑‍🔧 Chuyên gia: <%= expert != null ? expert.getFullName() : "Không rõ" %></p>
                <p>🕓 Giờ/ngày: <%= cart.getHoursPerDay() %> giờ</p>
                <p>📝 Ghi chú: <%= cart.getNotes() %></p>

                <h6 class="mt-3">🧾 Dịch vụ đã chọn:</h6>
                <ul>
                    <% for (CareService s : services) { %>
                        <li><%= s.getName() %> - <%= s.getPrice() %> VNĐ - <%= s.getDurationDays() %> ngày</li>
                    <% } %>
                </ul>

                <h5 class="text-danger">Tổng tiền: <%= cart.getTotalPrice() %> VNĐ</h5>

                <p class="mt-2"><strong>📌 Trạng thái:</strong>
                    <span class="badge <%= badgeClass %>"><%= statusText %></span>
                </p>

                <div class="mt-3 d-flex gap-2 flex-wrap">
                    <% if ("pending".equals(status) || "rejected".equals(status)) { %>
                        <form method="post" action="delete-care-cart">
                            <input type="hidden" name="cartId" value="<%= cart.getCartId() %>"/>
                            <button type="submit" class="btn btn-danger">❌ Xóa đơn</button>
                        </form>
                        <a href="edit-care-cart.jsp?cartId=<%= cart.getCartId() %>" class="btn btn-primary">✏️ Chỉnh sửa</a>
                    <% } else if ("approved".equals(status)) { %>
                        <form action="care-cart" method="get">
                            <input type="hidden" name="action" value="process-checkout"/>
                            <input type="hidden" name="cartId" value="<%= cart.getCartId() %>"/>
                            <button type="submit" class="btn btn-success">💰 Thanh toán</button>
                        </form>
                    <% } else { %>
                        <button class="btn btn-outline-secondary" disabled>Không thể sửa</button>
                    <% } %>
                </div>
            </div>
        </div>
    <%
            }
        }
    %>

    <div class="mt-4 text-center">
        <a href="book-care.jsp" class="btn btn-outline-success">🛍️ Tiếp tục mua sắm dịch vụ</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Tự động ẩn alert sau 3 giây
    setTimeout(function () {
        const alert = document.getElementById("alertBox");
        if (alert) {
            alert.classList.remove("show");
            alert.classList.add("fade");
            setTimeout(() => alert.style.display = 'none', 500);
        }
    }, 3000);
</script>
</body>
</html>
