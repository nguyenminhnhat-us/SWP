<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
<<<<<<< HEAD
    <title>Xác nhận thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/header-style.css">
=======
    <title>Xác nhận thanh toán </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #171717;
            color: white;
        }
        .invoice-box {
            max-width: 800px;
            margin: auto;
            padding: 30px;
            border: 1px solid #eee;
            box-shadow: 0 0 10px rgba(0, 0, 0, .15);
            font-size: 16px;
            line-height: 24px;
            font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
            color: #555;
            background-color: #fff;
            border-radius: 8px;
        }
        .invoice-box table {
            width: 100%;
            line-height: inherit;
            text-align: left;
        }
        .invoice-box table td {
            padding: 5px;
            vertical-align: top;
        }
        .invoice-box table tr.top table td {
            padding-bottom: 20px;
        }
        .invoice-box table tr.information table td {
            padding-bottom: 40px;
        }
        .invoice-box table tr.heading td {
            background: #eee;
            border-bottom: 1px solid #ddd;
            font-weight: bold;
        }
        .invoice-box table tr.item td {
            border-bottom: 1px solid #eee;
        }
        .invoice-box table tr.total td:nth-child(2) {
            border-top: 2px solid #eee;
            font-weight: bold;
        }
    </style>
>>>>>>> 0517b3c45e1915473af6ab55ae6de0b26642502b
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
