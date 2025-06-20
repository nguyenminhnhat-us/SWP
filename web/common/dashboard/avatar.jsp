<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    model.User user = (model.User) request.getAttribute("user");
    if (user == null) {
        user = (model.User) session.getAttribute("user");
    }
    // DB đã lưu avatar_path bắt đầu bằng /images/...
    String avatarPath = (user != null && user.getAvatarPath() != null && !user.getAvatarPath().isEmpty())
        ? (request.getContextPath() + user.getAvatarPath())
        : (request.getContextPath() + "/images/banner 3.jpg");
%>
<div class="dashboard__top-wrap mb-4">
    <div class="dashboard__instructor-info d-flex align-items-center">
        <div class="dashboard__instructor-info-left d-flex align-items-center">
            <div class="me-4 text-center">
                <!-- Avatar Image -->
                <div class="thumb mb-2" id="profileImageContainer">
                    <img src="<%=avatarPath%>" alt="Profile Image" id="profileImage">
                </div>
                <!-- Upload Form -->
                <form action="${pageContext.request.contextPath}/dashboard/profile" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="upload_avatar">
                    <input type="file" id="imageUpload" name="avatar" accept="image/*" required class="form-control form-control-sm mb-2">
                    <button type="submit" class="btn btn-success btn-sm">Tải ảnh lên</button>
                </form>
            </div>
            <div class="content">
                <h4 class="title mb-0"><c:out value="${user.fullName}"/></h4>
            </div>
        </div>
    </div>
</div>

<style>
    #profileImageContainer {
        position: relative;
        width: 120px;
        height: 120px;
        border-radius: 50%;
        overflow: hidden;
        border: 3px solid #28a745;
        background: #fff;
        margin-left: auto;
        margin-right: auto;
    }

    #profileImage {
        width: 100%;
        height: 100%;
        object-fit: cover; /* This makes the image cover the area without distortion */
        display: block;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const imageUpload = document.getElementById('imageUpload');
        const profileImage = document.getElementById('profileImage');

        imageUpload.addEventListener('change', function (event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    profileImage.src = e.target.result;
                }
                reader.readAsDataURL(file);
            }
        });
    });
</script>
