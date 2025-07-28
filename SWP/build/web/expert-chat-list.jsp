<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<h3>Danh sách cu?c trò chuy?n v?i khách hàng</h3>

<c:choose>
    <c:when test="${not empty consultations}">
        <ul class="list-group">
            <c:forEach var="c" items="${consultations}">
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    <div>
                        ?? <strong>Cu?c trò chuy?n v?i User #${c.userId}</strong><br/>
                        ? Ngày h?n: <fmt:formatDate value="${c.appointmentDate}" pattern="dd/MM/yyyy" />
                        <c:if test="${not empty c.appointmentTime}">
                            ? <fmt:formatDate value="${c.appointmentTime}" pattern="HH:mm" type="time"/>
                        </c:if><br/>
                        ? Tình tr?ng: 
                        <c:choose>
                            <c:when test="${c.status == 'pending'}">? ?ang ch?</c:when>
                            <c:when test="${c.status == 'approved'}">? ?ã ch?p nh?n</c:when>
                            <c:when test="${c.status == 'rejected'}">? ?ã t? ch?i</c:when>
                            <c:otherwise>${c.status}</c:otherwise>
                        </c:choose>
                    </div>
                    <a href="chat?consultationId=${c.consultationId}" class="btn btn-primary btn-sm">Xem chi ti?t</a>
                </li>
            </c:forEach>
        </ul>
    </c:when>
    <c:otherwise>
        <p>Không có cu?c trò chuy?n nào ???c tìm th?y.</p>
    </c:otherwise>
</c:choose>
