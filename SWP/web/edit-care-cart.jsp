<%@ page import="java.util.List" %>
<%@ page import="model.*, dal.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int cartId = Integer.parseInt(request.getParameter("cartId"));
    CareCartDAO cartDAO = new CareCartDAO();
    CareCart cart = cartDAO.getCareCartById(cartId); // ✅ dùng đúng tên hàm

    if (cart == null || cart.getUserId() != user.getUserId() || !"pending".equals(cart.getStatus())) {
        response.sendRedirect("care-cart.jsp?error=not_editable");
        return;
    }

    List<CareService> allServices = new CareServiceDAO().getAllServices();
    List<CareService> selectedServices = cartDAO.getServicesByCartId(cartId);
    List<User> experts = new UserDAO().getAllExperts();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa đơn chăm sóc cây</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-5">
    <h2>✏️ Chỉnh sửa đơn chăm sóc cây</h2>
    <form action="update-care-cart" method="post">
        <input type="hidden" name="cartId" value="<%= cart.getCartId() %>"/>

        <div class="mb-3">
            <label class="form-label">Tên cây:</label>
            <input type="text" name="plantName" class="form-control" value="<%= cart.getPlantName() %>" required/>
        </div>

        <div class="mb-3">
            <label class="form-label">Ngày giao cây:</label>
            <input type="date" name="dropOffDate" class="form-control" value="<%= cart.getDropOffDate() %>" required/>
        </div>

        <div class="mb-3">
            <label class="form-label">Giờ hẹn:</label>
            <input type="time" name="appointmentTime" class="form-control" value="<%= cart.getAppointmentTime() %>" required/>
        </div>

        <div class="mb-3">
            <label class="form-label">Số giờ mỗi ngày:</label>
            <input type="number" name="hoursPerDay" min="1" max="12" class="form-control" value="<%= cart.getHoursPerDay() %>" required/>
        </div>

        <div class="mb-3">
            <label class="form-label">Ghi chú:</label>
            <textarea name="notes" class="form-control"><%= cart.getNotes() != null ? cart.getNotes() : "" %></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Hình thức chăm sóc:</label><br/>
            <input type="radio" name="locationType" value="at_home" <%= "at_home".equals(cart.getLocationType()) ? "checked" : "" %>/> Tại nhà
            <input type="radio" name="locationType" value="in_store" <%= "in_store".equals(cart.getLocationType()) ? "checked" : "" %>/> Tại cửa hàng
        </div>

        <div class="mb-3" id="addressField" style="<%= "at_home".equals(cart.getLocationType()) ? "" : "display:none;" %>">
            <label class="form-label">Địa chỉ:</label>
            <input type="text" name="homeAddress" class="form-control" value="<%= cart.getHomeAddress() != null ? cart.getHomeAddress() : "" %>"/>
        </div>

        <div class="mb-3">
            <label class="form-label">Chuyên gia:</label>
            <select name="expertId" class="form-select" required>
                <option value="">-- Chọn chuyên gia --</option>
                <% for (User expert : experts) { %>
                    <option value="<%= expert.getUserId() %>" <%= expert.getUserId() == cart.getExpertId() ? "selected" : "" %>>
                        <%= expert.getFullName() %>
                    </option>
                <% } %>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Dịch vụ:</label><br/>
            <% for (CareService service : allServices) {
                boolean isSelected = selectedServices.stream().anyMatch(s -> s.getServiceId() == service.getServiceId());
            %>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="serviceIds" value="<%= service.getServiceId() %>" 
                        <%= isSelected ? "checked" : "" %>/>
                    <label class="form-check-label"><%= service.getName() %> - <%= service.getPrice() %> VNĐ</label>
                </div>
            <% } %>
        </div>

        <button type="submit" class="btn btn-success">💾 Cập nhật đơn</button>
        <a href="care-cart.jsp" class="btn btn-secondary">⬅️ Quay lại</a>
    </form>
</div>

<script>
    document.querySelectorAll('input[name="locationType"]').forEach(function (radio) {
        radio.addEventListener('change', function () {
            const addressField = document.getElementById('addressField');
            addressField.style.display = this.value === 'at_home' ? 'block' : 'none';
        });
    });
</script>
</body>
</html>
