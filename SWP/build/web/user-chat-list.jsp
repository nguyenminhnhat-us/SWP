<%@ page import="java.util.*, model.*, dal.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !"user".equals(currentUser.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Consultation> consultations = ConsultationDAO.getConsultationsByUserId(currentUser.getUserId());
%>

<html>
<head>
    <title>Chat của tôi</title>
</head>
<body>
    <h2>Danh sách tư vấn đã tạo</h2>
    <ul>
        <% for (Consultation consult : consultations) { %>
            <li>
                <a href="chat.jsp?consultationId=<%= consult.getConsultationId() %>">
                    Chuyên gia: <%= consult.getExpertId() %> | Ngày: <%= consult.getAppointmentDate() %>
                </a>
            </li>
        <% } %>
    </ul>
</body>
</html>
