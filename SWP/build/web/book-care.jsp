<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dal.UserDAO" %>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.CareServiceDAO" %>
<%@ page import="model.CareService" %>
<%@ page import="java.util.List" %>
<%
    CareServiceDAO serviceDAO = new CareServiceDAO();
    UserDAO userDAO = new UserDAO();
    List<CareService> combos = serviceDAO.getAllServices();
    List<User> experts = userDAO.getExpertsWithProfiles();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lịch chăm sóc cây</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 25px;
        }
        .form-section {
            margin-bottom: 25px;
        }
        .form-label {
            font-weight: 500;
            color: #34495e;
        }
        .expert-card {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background: #fff;
            transition: transform 0.2s;
        }
        .expert-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .expert-card input[type="radio"] {
            transform: scale(1.4);
            margin: 10px 15px 0 0;
        }
        .expert-details {
            display: flex;
            gap: 20px;
            align-items: flex-start;
        }
        .expert-details img {
            border-radius: 8px;
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        .gallery img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            margin-right: 8px;
            border: 1px solid #dee2e6;
        }
        .btn-primary {
            background-color: #28a745;
            border-color: #28a745;
            padding: 10px 25px;
            font-weight: 500;
        }
        .btn-primary:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }
        .btn-outline-success {
            margin-bottom: 20px;
        }
        .form-control, .form-check-input, .form-select {
            border-radius: 6px;
        }
        .form-check-label {
            margin-left: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="index.jsp" class="btn btn-outline-success">🛍️ Tiếp tục mua sắm</a>
    <h2>🗓️ Đặt lịch chăm sóc cây</h2>

    <form action="book-care" method="post">
        <div class="form-section">
            <label class="form-label">🌱 Tên cây:</label>
            <input type="text" name="plantName" class="form-control" required>
        </div>

        <div class="form-section">
            <label class="form-label">📦 Chọn combo dịch vụ (theo ngày):</label>
            <div class="mb-3">
                <% for (CareService s : combos) { %>
                    <div class="form-check">
                        <input type="checkbox" name="serviceIds" value="<%= s.getServiceId() %>" class="form-check-input">
                        <label class="form-check-label"><%= s.getName() %> - <%= s.getPrice() %> VND/gói</label>
                    </div>
                <% } %>
            </div>
        </div>

        <h2>👨‍💼 Chọn chuyên gia:</h2>
        <div class="expert-list">
            <% for (User expert : experts) { %>
                <div class="expert-card">
                    <input type="radio" name="expertId" value="<%= expert.getUserId() %>" class="form-check-input" required>
                    <div class="expert-details">
                        <img src="<%= expert.getAvatarPath() %>" alt="Avatar">
                        <div>
                            <h5 class="mb-1"><%= expert.getFullName() %></h5>
                            <div class="text-muted mb-1"><%= expert.getEmail() %></div>
                            <div class="text-muted mb-1">📞 <%= expert.getPhone() == null ? "Chưa có" : expert.getPhone() %></div>
                            <div class="text-muted mb-1">🎓 Kinh nghiệm: <%= expert.getExperienceYears() %> năm</div>
                            <div class="text-muted mb-1">💰 Giá/ngày: <%= expert.getPricePerDay() %> VND</div>
                            <div class="text-muted mb-1">📝 Giới thiệu: <%= expert.getBio() %></div>
                            <div class="text-muted mb-1">🏆 Thành tựu: <%= expert.getAchievements() %></div>
                            <div class="text-muted mb-1">🌿 Chuyên môn: <%= expert.getSpecialties() %></div>
                            <div class="gallery mt-2">
                                <% if (expert.getGallery1() != null) { %>
                                    <img src="<%= expert.getGallery1() %>" alt="gallery1">
                                <% } %>
                                <% if (expert.getGallery2() != null) { %>
                                    <img src="<%= expert.getGallery2() %>" alt="gallery2">
                                <% } %>
                                <% if (expert.getGallery3() != null) { %>
                                    <img src="<%= expert.getGallery3() %>" alt="gallery3">
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>

        <div class="form-section">
            <label class="form-label">📍 Chăm sóc tại:</label>
            <div class="form-check form-check-inline">
                <input type="radio" name="locationType" value="in_store" class="form-check-input" checked>
                <label class="form-check-label">Cửa hàng</label>
            </div>
            <div class="form-check form-check-inline">
                <input type="radio" name="locationType" value="at_home" class="form-check-input">
                <label class="form-check-label">Tại nhà</label>
            </div>
        </div>

        <div class="form-section">
            <label class="form-label">🏠 Địa chỉ (nếu tại nhà):</label>
            <textarea name="homeAddress" rows="3" class="form-control"></textarea>
        </div>

        <div class="form-section">
            <label class="form-label">🗓️ Chọn ngày chăm cây:</label>
            <input type="text" name="careDates" id="careDates" class="form-control" required>
        </div>

        <div class="form-section">
            <label class="form-label">⏰ Giờ hẹn:</label>
            <input type="time" name="appointmentTime" class="form-control">
        </div>

        <div class="form-section">
            <label class="form-label">📝 Ghi chú thêm:</label>
            <textarea name="notes" rows="4" class="form-control"></textarea>
        </div>

        <div class="form-section">
            <label class="form-label">🕒 Số giờ mỗi ngày chăm sóc:</label>
            <input type="number" name="hoursPerDay" min="1" max="24" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Gửi đơn chăm sóc</button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    flatpickr("#careDates", {
        mode: "multiple",
        dateFormat: "Y-m-d",
        locale: {
            firstDayOfWeek: 1
        }
    });
</script>
</body>
</html>