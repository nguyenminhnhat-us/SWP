<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CareService" %>
<%@ page import="model.User" %>
<html>
<head>
    <title>Hóa đơn chăm sóc cây</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
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
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(145deg, var(--gradient-start), var(--gradient-mid), var(--gradient-end));
            padding: 20px;
            color: var(--text-dark);
            line-height: 1.8;
            overflow-x: hidden;
        }

        .container {
            max-width: 800px;
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
            color: var(--text-dark);
            font-family: 'Playfair Display', serif;
            font-weight: 600;
            font-size: 2rem;
            margin-bottom: 25px;
            text-align: center;
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

        h3 {
            color: var(--primary-color);
            font-weight: 500;
            font-size: 1.5rem;
            text-align: right;
        }

        .invoice-section {
            margin-bottom: 20px;
            padding: 15px;
            background: var(--card-background);
            border-radius: 8px;
            border-left: 4px solid var(--primary-color);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }

        .invoice-section:hover {
            transform: translateY(-3px);
        }

        .invoice-label {
            font-weight: 500;
            color: #34495e;
            margin-bottom: 5px;
            font-size: 1.1rem;
        }

        .list-group-item {
            border-radius: 6px;
            margin-bottom: 5px;
            background: rgba(255, 255, 255, 0.7);
            border: 1px solid rgba(0, 0, 0, 0.1);
            transition: background 0.3s ease;
        }

        .list-group-item:hover {
            background: rgba(255, 255, 255, 0.9);
        }

        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            padding: 10px 25px;
            font-weight: 500;
            border-radius: 8px;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, var(--primary-hover), var(--secondary-hover));
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26, 188, 156, 0.3);
        }

        .btn-outline-secondary {
            margin-top: 15px;
            border-color: var(--secondary-color);
            color: var(--secondary-color);
            border-radius: 8px;
            padding: 8px 20px;
            transition: all 0.3s ease;
        }

        .btn-outline-secondary:hover {
            background: var(--secondary-color);
            color: white;
            transform: translateY(-2px);
        }

        .error-message {
            color: #dc3545;
            font-weight: 500;
            text-align: center;
            padding: 15px;
            background: rgba(255, 245, 245, 0.8);
            border-radius: 8px;
            border-left: 4px solid #dc3545;
        }

        hr {
            border-top: 2px solid rgba(255, 255, 255, 0.3);
            margin: 20px 0;
        }

        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            h2 {
                font-size: 1.75rem;
            }

            h3 {
                font-size: 1.25rem;
                text-align: center;
            }

            .invoice-section {
                padding: 10px;
            }

            .btn-primary, .btn-outline-secondary {
                width: 100%;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>🌿 Hóa đơn chăm sóc cây</h2>

    <c:if test="${not empty expert}">
        <div class="invoice-section">
            <div class="invoice-label">Tên cây:</div>
            <p class="text-muted">${plantName}</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Chuyên gia:</div>
            <p class="text-muted">${expert.fullName}</p>
            <div class="invoice-label">Giá chuyên gia/ngày:</div>
            <p class="text-muted">${expert.pricePerDay} VNĐ</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Thời gian hẹn:</div>
            <p class="text-muted">${appointmentTime}</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Hình thức:</div>
            <p class="text-muted">${locationType}</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Địa chỉ:</div>
            <p class="text-muted">${homeAddress}</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Ghi chú:</div>
            <p class="text-muted">${notes}</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Số giờ/ngày:</div>
            <p class="text-muted">${hoursPerDay}</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Ngày chăm sóc:</div>
            <ul class="list-group">
                <c:forEach var="date" items="${careDates}">
                    <li class="list-group-item">${date}</li>
                </c:forEach>
            </ul>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Dịch vụ đã chọn:</div>
            <ul class="list-group">
                <c:forEach var="s" items="${selectedServices}">
                    <li class="list-group-item">${s.name} - ${s.price} VNĐ</li>
                </c:forEach>
            </ul>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Tổng phí dịch vụ:</div>
            <p class="text-muted">${totalServiceCost} VNĐ</p>
        </div>

        <div class="invoice-section">
            <div class="invoice-label">Chi phí chuyên gia:</div>
            <p class="text-muted">${expertCost} VNĐ</p>
        </div>

        <hr>

        <div class="invoice-section">
            <h3>Tổng cộng: ${totalCost} VNĐ</h3>
        </div>

        <form action="save-care-cart" method="post">
            <input type="hidden" name="plantName" value="${plantName}">
            <input type="hidden" name="dropOffDate" value="${careDates[0]}">
            <input type="hidden" name="appointmentTime" value="${appointmentTime}">
            <input type="hidden" name="locationType" value="${locationType}">
            <input type="hidden" name="homeAddress" value="${homeAddress}">
            <input type="hidden" name="notes" value="${notes}">
            <input type="hidden" name="expertId" value="${expert.userId}">
            <input type="hidden" name="hoursPerDay" value="${hoursPerDay}">
            <input type="hidden" name="totalPrice" value="${totalCost}">
            <c:forEach var="s" items="${selectedServices}">
                <input type="hidden" name="serviceIds" value="${s.serviceId}">
            </c:forEach>
            <button type="submit" class="btn btn-primary">Xác nhận lưu vào giỏ hàng</button>
        </form>
    </c:if>

    <c:if test="${empty expert}">
        <p class="error-message">❌ Không tìm thấy chuyên gia. Vui lòng quay lại và chọn lại.</p>
        <a href="book-care.jsp" class="btn btn-outline-secondary">🔙 Quay lại trang đặt lịch</a>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>