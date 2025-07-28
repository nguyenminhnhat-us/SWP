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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600&family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #1abc9c; /* Vibrant turquoise for primary actions */
            --primary-hover: #16a085; /* Darker turquoise for hover */
            --secondary-color: #3498db; /* Bright blue for secondary elements */
            --secondary-hover: #2c81ba; /* Darker blue for hover */
            --accent-color: #f39c12; /* Warm orange for highlights */
            --text-dark: #2c2c2c; /* Deep charcoal for text */
            --text-muted: #95a5a6; /* Soft gray for secondary text */
            --background-light: #e8f5e9; /* Light green from image */
            --card-background: rgba(255, 255, 255, 0.85); /* Glassmorphism white with more transparency */
            --card-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            --glass-blur: blur(12px);
            --gradient-start: #d4e157; /* Light yellow-green */
            --gradient-mid: #4caf50; /* Vibrant green */
            --gradient-end: #81d4fa; /* Light blue */
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(145deg, var(--gradient-start), var(--gradient-mid), var(--gradient-end));
            padding: 2.5rem;
            color: var(--text-dark);
            line-height: 1.8;
            overflow-x: hidden;
        }

        .container {
            max-width: 1024px;
            background: linear-gradient(145deg, rgba(var(--gradient-start), 0.2), rgba(var(--gradient-mid), 0.2), rgba(var(--gradient-end), 0.2));
            backdrop-filter: var(--glass-blur);
            padding: 3rem;
            border-radius: 20px;
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
            border-radius: 20px 20px 0 0;
        }

        h2 {
            font-family: 'Playfair Display', serif;
            color: var(--text-dark);
            font-weight: 600;
            font-size: 2.25rem;
            margin-bottom: 2.25rem;
            position: relative;
            text-align: center;
            letter-spacing: 0.5px;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            border-radius: 2px;
        }

        .form-section {
            margin-bottom: 2.5rem;
            padding: 0 1rem;
        }

        .form-label {
            font-family: 'Roboto', sans-serif;
            font-weight: 500;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: color 0.3s ease;
        }

        .form-label:hover {
            color: var(--primary-color);
        }

        .expert-card {
            border: none;
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            background: white;
            backdrop-filter: var(--glass-blur);
            box-shadow: var(--card-shadow);
            transition: transform 0.4s ease, box-shadow 0.4s ease;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .expert-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .expert-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 8px;
            height: 100%;
            background: linear-gradient(to bottom, var(--primary-color), var(--secondary-color));
            transition: width 0.4s ease;
        }

        .expert-card:hover::before {
            width: 16px;
        }

        .expert-card input[type="radio"] {
            transform: scale(1.5);
            margin: 1rem 1.5rem 0 0;
            accent-color: var(--primary-color);
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .expert-card input[type="radio"]:hover {
            transform: scale(1.7);
        }

        .expert-details {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .expert-details img {
            border-radius: 14px;
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 3px solid var(--accent-color);
            transition: transform 0.4s ease, border-color 0.4s ease;
        }

        .expert-details img:hover {
            transform: scale(1.08);
            border-color: var(--primary-color);
        }

        .expert-details h5 {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--text-dark);
        }

        .expert-details .text-muted {
            font-size: 0.95rem;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.3s ease;
        }

        .expert-details .text-muted:hover {
            color: var(--secondary-color);
        }

        .gallery {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .gallery img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 12px;
            border: 2px solid var(--accent-color);
            transition: transform 0.4s ease, border-color 0.4s ease;
        }

        .gallery img:hover {
            transform: scale(1.12);
            border-color: var(--primary-hover);
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            padding: 1rem 2.5rem;
            font-family: 'Roboto', sans-serif;
            font-weight: 500;
            font-size: 1.1rem;
            border-radius: 12px;
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, var(--primary-hover), var(--secondary-hover));
            transform: translateY(-4px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
        }

        .btn-outline-success {
            border-color: var(--secondary-color);
            color: var(--secondary-color);
            border-radius: 12px;
            padding: 0.75rem 2rem;
            font-family: 'Roboto', sans-serif;
            font-weight: 500;
            margin-bottom: 2rem;
            transition: all 0.4s ease;
        }

        .btn-outline-success:hover {
            background: var(--secondary-color);
            color: white;
            border-color: var(--secondary-hover);
            transform: translateY(-3px);
        }

        .form-control, .form-select {
            border-radius: 12px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            padding: 0.9rem;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: var(--glass-blur);
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 10px rgba(26, 188, 156, 0.3);
            background: white;
        }

        .form-check-input {
            border-radius: 4px;
            accent-color: var(--primary-color);
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .form-check-input:checked {
            transform: scale(1.2);
        }

        .form-check-label {
            font-size: 1rem;
            color: var(--text-dark);
            margin-left: 0.75rem;
            transition: color 0.3s ease;
        }

        .form-check-label:hover {
            color: var(--primary-color);
        }

        .form-check-inline {
            margin-right: 2.5rem;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 130px;
            border-radius: 12px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 2rem;
            }

            h2 {
                font-size: 1.85rem;
            }

            .expert-details {
                flex-direction: column;
                align-items: flex-start;
                gap: 1.25rem;
            }

            .expert-details img {
                width: 80px;
                height: 80px;
            }

            .gallery img {
                width: 65px;
                height: 65px;
            }

            .btn-primary {
                padding: 0.85rem 2rem;
                font-size: 1rem;
            }

            .form-section {
                padding: 0 0.5rem;
            }
        }

        @media (max-width: 576px) {
            .container {
                padding: 1.5rem;
            }

            h2 {
                font-size: 1.5rem;
            }

            .expert-card {
                padding: 1.5rem;
            }

            .form-label {
                font-size: 1rem;
            }
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