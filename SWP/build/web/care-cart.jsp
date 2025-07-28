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
    <style>
        :root {
            --primary-color: #1abc9c; /* Vibrant turquoise */
            --primary-hover: #16a085; /* Darker turquoise */
            --secondary-color: #3498db; /* Bright blue */
            --secondary-hover: #2c81ba; /* Darker blue */
            --accent-color: #f39c12; /* Warm orange */
            --text-dark: #2c2c2c; /* Deep charcoal */
            --text-muted: #95a5a6; /* Soft gray */
            --background-light: #e8f5e9; /* Light green */
            --card-background: rgba(255, 255, 255, 0.85); /* Glassmorphism white */
            --card-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            --glass-blur: blur(12px);
            --gradient-start: #d4e157; /* Light yellow-green */
            --gradient-mid: #4caf50; /* Vibrant green */
            --gradient-end: #81d4fa; /* Light blue */
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(145deg, var(--gradient-start), var(--gradient-mid), var(--gradient-end));
            padding: 20px;
            color: var(--text-dark);
            line-height: 1.8;
            overflow-x: hidden;
        }

        .container {
            max-width: 900px;
            background: linear-gradient(145deg, rgba(var(--gradient-start), 0.2), rgba(var(--gradient-mid), 0.2), rgba(var(--gradient-end), 0.2));
            backdrop-filter: var(--glass-blur);
            padding: 30px;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            margin: 0 auto;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--accent-color));
            border-radius: 15px 15px 0 0;
        }

        h2 {
            font-family: 'Playfair Display', serif;
            font-weight: 600;
            font-size: 2rem;
            margin-bottom: 25px;
            text-align: center;
            color: var(--text-dark);
            position: relative;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .card {
            background: var(--card-background);
            border: none;
            border-radius: 12px;
            margin-bottom: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .card-body {
            padding: 20px;
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .card p {
            margin-bottom: 10px;
            color: var(--text-muted);
            font-size: 1rem;
        }

        h6 {
            font-size: 1.2rem;
            font-weight: 500;
            color: var(--text-dark);
            margin-top: 15px;
        }

        ul {
            list-style-type: none;
            padding-left: 0;
        }

        ul li {
            background: rgba(255, 255, 255, 0.7);
            padding: 8px 12px;
            margin-bottom: 5px;
            border-radius: 6px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            transition: background 0.3s ease;
        }

        ul li:hover {
            background: rgba(255, 255, 255, 0.9);
        }

        .text-danger {
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 15px;
        }

        .badge {
            font-size: 0.9rem;
            padding: 6px 12px;
            border-radius: 10px;
        }

        .btn {
            padding: 8px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, var(--primary-hover), var(--secondary-hover));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26, 188, 156, 0.3);
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
            color: white;
        }

        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }

        .btn-outline-secondary {
            border-color: var(--secondary-color);
            color: var(--secondary-color);
        }

        .btn-outline-secondary:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
        }

        .alert {
            border-radius: 8px;
            border-left: 4px solid;
            margin-bottom: 20px;
            font-size: 1rem;
        }

        .alert-success {
            background: rgba(144, 238, 144, 0.2);
            border-color: #28a745;
        }

        .alert-danger {
            background: rgba(255, 182, 193, 0.2);
            border-color: #dc3545;
        }

        .alert-info {
            background: rgba(173, 216, 230, 0.2);
            border-color: #17a2b8;
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            h2 {
                font-size: 1.75rem;
            }

            .card-body {
                padding: 15px;
            }

            .btn {
                width: 100%;
                margin-bottom: 10px;
            }
        }
    </style>
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