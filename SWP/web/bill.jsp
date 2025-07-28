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
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }
        .container {
            max-width: 800px;
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
        h3 {
            color: #28a745;
            font-weight: 500;
        }
        .invoice-section {
            margin-bottom: 20px;
        }
        .invoice-label {
            font-weight: 500;
            color: #34495e;
            margin-bottom: 5px;
        }
        .list-group-item {
            border-radius: 6px;
            margin-bottom: 5px;
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
        .btn-outline-secondary {
            margin-top: 15px;
        }
        .error-message {
            color: #dc3545;
            font-weight: 500;
        }
        hr {
            border-top: 2px solid #e9ecef;
            margin: 20px 0;
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