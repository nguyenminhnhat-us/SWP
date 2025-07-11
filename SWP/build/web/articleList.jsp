<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tin Tức - Vườn Cây Đà Nẵng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Bootstrap 5 -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header-style.css">
        <style>
            body {
                background-color: #171717;
                color: #fff;
            }
            .container {
                margin-top: 20px;
            }
            .article-card {
                background-color: #9ED2BB;
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 10px;
            }
            .article-title {
                color: #28a745;
                font-weight: bold;
            }
            .article-meta {
                font-size: 0.9rem;
                color: #666;
            }
            .article-content {
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/common/home/header.jsp" />

        <div class="container">
            <h2 class="text-success text-center my-4">Tin Tức</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger text-center">${error}</div>
            </c:if>
            <c:forEach var="article" items="${articles}">
                <div class="article-card">
                    <h4 class="article-title">${article.title}</h4>
                    <p class="article-meta">
                        <i class="fas fa-user"></i> Tác giả ID: ${article.authorId} |
                        <i class="fas fa-calendar"></i> Ngày tạo: <fmt:formatDate value="${article.createdAt}" pattern="dd/MM/yyyy HH:mm" /> |
                    <i class="fas fa-edit"></i> Cập nhật: <fmt:formatDate value="${article.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                    </p>
                    <div class="article-content">${article.content}</div>
                    <p><strong>Danh mục:</strong> ${article.category}</p>
                </div>
            </c:forEach>
            <c:if test="${empty articles and empty error}">
                <div class="alert alert-warning text-center">Không có bài viết nào để hiển thị.</div>
            </c:if>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>