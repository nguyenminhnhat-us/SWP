<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<h3>Danh s�ch cu?c tr� chuy?n v?i kh�ch h�ng</h3>

<c:choose>
    <c:when test="${not empty consultations}">
        <ul class="list-group">
            <c:forEach var="c" items="${consultations}">
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    <div>
                        ?? <strong>Cu?c tr� chuy?n v?i User #${c.userId}</strong><br/>
                        ? Ng�y h?n: <fmt:formatDate value="${c.appointmentDate}" pattern="dd/MM/yyyy" />
                        <c:if test="${not empty c.appointmentTime}">
                            ? <fmt:formatDate value="${c.appointmentTime}" pattern="HH:mm" type="time"/>
                        </c:if><br/>
                        ? T�nh tr?ng: 
                        <c:choose>
                            <c:when test="${c.status == 'pending'}">? ?ang ch?</c:when>
                            <c:when test="${c.status == 'approved'}">? ?� ch?p nh?n</c:when>
                            <c:when test="${c.status == 'rejected'}">? ?� t? ch?i</c:when>
                            <c:otherwise>${c.status}</c:otherwise>
                        </c:choose>
                    </div>
                    <a href="chat?consultationId=${c.consultationId}" class="btn btn-primary btn-sm">Xem chi ti?t</a>
                </li>
            </c:forEach>
        </ul>
    </c:when>
    <c:otherwise>
        <p>Kh�ng c� cu?c tr� chuy?n n�o ???c t�m th?y.</p>
    </c:otherwise>
</c:choose>
