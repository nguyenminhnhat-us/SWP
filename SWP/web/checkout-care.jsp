<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.CareCart" %>
<%@ page import="model.CareService" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    CareCart cart = (CareCart) session.getAttribute("checkoutCart");
    List<CareService> services = (List<CareService>) session.getAttribute("checkoutServices");
    String totalAmount = (String) session.getAttribute("checkoutAmount");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>🧾 Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">🧾 Xác nhận thanh toán đơn chăm sóc cây</h2>

    <c:if test="${not empty checkoutCart}">
        <div class="card shadow">
            <div class="card-body">
                <h5>🌿 Cây: ${checkoutCart.plantName}</h5>
                <p>📅 Ngày hẹn: ${checkoutCart.dropOffDate}</p>
                <p>🕒 Giờ hẹn: ${checkoutCart.appointmentTime}</p>
                <p>📍 Địa chỉ: ${checkoutCart.homeAddress}</p>
                <p>👨‍🔧 Chuyên gia ID: ${checkoutCart.expertId}</p>
                <p>🕘 Giờ mỗi ngày: ${checkoutCart.hoursPerDay} giờ</p>
                <p>📝 Ghi chú: ${checkoutCart.notes}</p>

                <h5 class="mt-4">📦 Dịch vụ đi kèm:</h5>
                <ul>
                    <c:forEach var="s" items="${checkoutServices}">
                        <li>${s.name} - ${s.price} VNĐ</li>
                    </c:forEach>
                </ul>

                <h4 class="text-danger mt-3">💰 Tổng tiền: ${checkoutAmount} VNĐ</h4>

                <hr/>

                <!-- 💵 COD Form -->
                <form action="${pageContext.request.contextPath}/care-cart?action=complete-checkout"
                      method="post" class="mt-3">
                    <input type="hidden" name="cartId" value="${checkoutCart.cartId}">
                    <input type="hidden" name="paymentMethod" value="cod">

                    <button type="submit" class="btn btn-success w-100">
                        💵 Thanh toán khi hoàn thành (COD)
                    </button>
                </form>

                <!-- 🏦 VNPAY Form -->
                <form action="${pageContext.request.contextPath}/ajax-care-payment"
                      method="post" class="mt-3">
                    <input type="hidden" name="cartId" value="${checkoutCart.cartId}">
                    <input type="hidden" name="amount" value="${checkoutAmount}">
                    <button type="submit" class="btn btn-primary w-100">
                        🏦 Thanh toán ngay qua VNPAY
                    </button>
                </form>
            </div>
        </div>
    </c:if>

    <c:if test="${empty checkoutCart}">
        <div class="alert alert-warning mt-4">
            ❌ Không tìm thấy đơn dịch vụ hoặc thông tin không hợp lệ. Vui lòng thử lại.
        </div>
    </c:if>
</div>
</body>
</html>
