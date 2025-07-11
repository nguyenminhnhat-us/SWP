<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header-style.css">
</head>
<body>
    <div class="container my-4">
        <div class="invoice-box">
            <table cellpadding="0" cellspacing="0">
                <tr class="top">
                    <td colspan="2">
                        <table>
                            <tr>
                                <td class="title">
                                    <h2 style="color: #333;">Hóa đơn</h2>
                                </td>
                                <td>
                                    Ngày tạo: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy" /><br>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="information">
                    <td colspan="2">
                        <table>
                            <tr>
                                <td>
                                    <strong>Thông tin người mua:</strong><br>
                                    Tên: ${sessionScope.user.fullName}<br>
                                    Email: ${sessionScope.user.email}<br>
                                    Địa chỉ: ${sessionScope.user.address}
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="heading">
                    <td>Sản phẩm</td>
                    <td style="text-align: right;">Giá</td>
                </tr>
                <c:forEach var="item" items="${sessionScope.checkoutCartItems}">
                    <tr class="item">
                        <td>${item.plant.name} (x${item.quantity})</td>
                        <td style="text-align: right;"><fmt:formatNumber value="${item.plant.price * item.quantity}" type="currency" currencySymbol="₫" /></td>
                    </tr>
                </c:forEach>
                <tr class="total">
                    <td></td>
                    <td style="text-align: right;">
                       <strong>Tổng tiền: <fmt:formatNumber value="${total}" type="currency" currencySymbol="₫" /></strong>
                    </td>
                </tr>
            </table>
            <div class="text-end mt-4">
                <form action="${pageContext.request.contextPath}/ajaxServlet" method="post" class="d-inline">
                    <input type="hidden" name="amount" value="${total}">
                    <button type="submit" class="btn btn-success">Xác nhận và Thanh toán VNPAY</button>
                </form>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary">Hủy</a>
            </div>
        </div>
    </div>
</body>
</html>
