<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thông tin cá nhân - Dashboard</title>
            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Font Awesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
            <style>
                .profile-section {
                    background: white;
                    border-radius: 10px;
                    padding: 20px;
                    margin-bottom: 20px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }

                .form-label {
                    font-weight: 600;
                }

                .alert {
                    margin-bottom: 20px;
                }

                .invalid-feedback {
                    display: none;
                    color: red;
                    font-size: 0.875em;
                }

                .password-match-message {
                    margin-top: 5px;
                    font-size: 0.875em;
                }

                .logo-bar {
                    background-color: #28a745;
                    /* Màu xanh Bootstrap chuẩn */
                    color: white;
                    /* Để chữ nổi trên nền xanh */
                    border-radius: 5px;
                    /* Tùy chọn: bo góc */
                }

                .logo-bar {
                    background-color: #28a745;
                    /* Màu xanh Bootstrap chuẩn */
                    border-radius: 5px;
                    /* Tùy chọn: bo góc */
                    padding: 15px;
                    display: flex;
                    flex-wrap: wrap;
                    align-items: center;
                    justify-content: space-between;

                }

                .logo img {
                    width: 150px;
                    /* tăng kích thước theo ý bạn */
                    height: auto;
                    /* giữ tỉ lệ ảnh */
                    margin-right: 15px;
                    /* thêm khoảng cách bên phải nếu muốn */
                }

                .logo h1 {
                    font-size: 24px;
                    margin: 0;
                    color: #2e7d32;
                }

                .logo small {
                    font-size: 14px;
                    color: gray;
                }

                .hotline-label {
                    text-transform: uppercase;
                    /* Viết hoa */
                    color: red;
                    /* Màu đỏ */
                    font-weight: bold;
                    /* (Tùy chọn) In đậm */
                }

                .hotline-number {
                    color: red;
                    font-weight: bold;
                    font-size: 18px;
                }

                .nav-link:hover,
                .dropdown-item:hover {
                    color: yellow !important;
                }

                .sidebar {
                    background-color: #171717;
                    padding: 15px;
                    color: #28a745;
                    /* chữ trắng cho tiêu đề */
                }

                .sidebar ul.list-group li.list-group-item {
                    background-color: #171717;
                    border: none;
                    /* bỏ viền */
                    padding-left: 0;
                    /* nếu muốn */
                }

                .sidebar ul.list-group li.list-group-item a {
                    color: #28a745;
                    /* xanh sáng */
                    text-decoration: none;
                    /* bỏ gạch chân */
                }

                .sidebar ul.list-group {
                    padding: 0;
                    /* bỏ padding mặc định */
                    margin: 0;
                    /* bỏ margin nếu có */
                }

                .sidebar ul.list-group li.list-group-item {
                    border: 1px solid #28a745 !important;
                    border-top: none;
                    /* bỏ viền trên của các ô, trừ ô đầu */
                    margin: 0;
                    /* bỏ khoảng cách giữa các ô */
                    border-radius: 0;
                    /* bỏ bo góc */
                    background-color: !important;
                    padding: 8px 12px;
                }

                /* Giữ viền trên cho ô đầu tiên */
                .sidebar ul.list-group li.list-group-item:first-child {
                    border-top: 1px solid #28a745 !important;
                    border-radius: 4px 4px 0 0;
                    /* bo góc trên */
                }

                /* Bo góc dưới cho ô cuối */
                .sidebar ul.list-group li.list-group-item:last-child {
                    border-radius: 0 0 4px 4px;
                }

                .sidebar ul.list-group li.list-group-item a:hover {
                    text-decoration: underline;
                }

                .banner-categories {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 20px;
                }

                .banner-categories .col-md-3 {
                    flex: 0 0 calc(25% - 20px);
                    box-sizing: border-box;
                    border: 3px solid #28a745;
                    padding: 2px;
                    border-radius: 10px;
                    transition: box-shadow 0.3s ease;
                    cursor: pointer;
                    background-color: #9ED2BB;
                }

                .banner-categories img {
                    width: 100%;
                    height: 250px;
                    object-fit: cover;
                }

                .banner-text {
                    font-weight: bold;
                    text-align: center;
                    margin-top: 20px;
                    color: #388e3c;
                    font-size: 20px;
                }

                .carousel-inner img {
                    width: 100%;
                    height: 450px;
                    object-fit: cover;
                    border-radius: 8px;
                }

                .bold-text1 {
                    display: inline-block;
                    /* Giúp viền gọn sát chữ */
                    border: 3px solid #28a745;
                    /* Viền xanh lá */
                    padding: 2px 6px;
                    /* Khoảng cách giữa chữ và viền */
                    border-radius: 4px;
                    /* Bo góc nhẹ */
                    font-weight: bold;
                    /* In đậm (áp dụng chung cho cả 3) */
                    margin: 5px 5px;
                    background-color: #f8f9fa;
                }

                .bold-text2 {
                    display: inline-block;
                    /* Giúp viền gọn sát chữ */
                    border: 3px solid #28a745;
                    /* Viền xanh lá */
                    padding: 2px 6px;
                    /* Khoảng cách giữa chữ và viền */
                    border-radius: 4px;
                    /* Bo góc nhẹ */
                    font-weight: bold;
                    /* In đậm (áp dụng chung cho cả 3) */
                    margin: 5px 5px;
                    background-color: #f8f9fa;
                }

                .bold-text3 {
                    display: inline-block;
                    /* Giúp viền gọn sát chữ */
                    border: 3px solid #28a745;
                    /* Viền xanh lá */
                    padding: 2px 6px;
                    /* Khoảng cách giữa chữ và viền */
                    border-radius: 4px;
                    /* Bo góc nhẹ */
                    font-weight: bold;
                    /* In đậm (áp dụng chung cho cả 3) */
                    margin: 5px 5px;
                    /* Tạo khoảng cách dọc giữa các dòng */
                    background-color: #f8f9fa;
                }

                .company-intro {
                    background-color: #9ED2BB;
                    padding: 30px;
                    border-radius: 10px;
                    margin-bottom: 40px;
                    font-size: 1.25rem;
                    /* Làm chữ to hơn (20px) */
                    line-height: 1.8;
                    /* Giãn dòng dễ đọc */
                    text-align: justify;
                    /* Căn đều chữ cho đẹp */
                    /* Màu chữ dễ nhìn */
                    margin-top: 15px;
                    color: white;
                }

                .company-intro img {
                    width: 100%;
                    /* Làm ảnh chiếm toàn bộ chiều ngang khung */
                    height: auto;
                    /* Giữ tỉ lệ ảnh */
                    object-fit: cover;
                    /* Cắt ảnh để lấp đầy khung mà không bị méo */
                    border-radius: 10px;
                    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
                    transition: transform 0.3s ease;
                }

                .commitment-section {
                    background-color: #171717;
                    color: white;
                    padding: 60px 20px;
                    margin-top: 40px;
                }

                .commitment-title {
                    font-size: 2.2rem;
                    font-weight: bold;
                    margin-bottom: 10px;
                }

                .commitment-subtitle {
                    font-size: 1.2rem;
                    margin-bottom: 40px;
                }

                .commitment-features {
                    display: flex;
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 30px;
                }

                .feature-box {
                    text-align: center;
                    flex: 1 1 200px;
                }

                .feature-icon {
                    width: 60px;
                    margin-bottom: 15px;
                }

                footer {
                    background-color: #388e3c;
                    color: white;
                    padding: 20px 0;
                }

                footer .container {
                    text-align: left;
                }

                footer a {
                    color: white;
                    text-decoration: none;
                }

                footer a:hover {
                    text-decoration: underline;
                }

                .password-field {
                    position: relative;
                }
                .toggle-password {
                    position: absolute;
                    right: 10px;
                    top: 50%;
                    transform: translateY(-50%);
                    cursor: pointer;
                    color: #6c757d;
                }
                .toggle-password:hover {
                    color: #495057;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../common/home/header.jsp" />
            <div class="container-fluid">
                <div class="row">
                    <!-- Sidebar -->
                    <div class="col-md-2 p-0">
                        <jsp:include page="../common/dashboard/sidebar.jsp" />
                    </div>

                    <!-- Main Content -->
                    <div class="col-md-10 p-4">
                        <h2 class="mb-4">Thông tin cá nhân</h2>

                        <!-- Hiển thị thông báo -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">${successMessage}</div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger">${errorMessage}</div>
                        </c:if>

                        <!-- Thông tin cơ bản -->
                        <div class="profile-section">
                            <h4 class="mb-4">Thông tin cơ bản</h4>
                            <form id="profileForm" action="${pageContext.request.contextPath}/dashboard/profile" method="post" onsubmit="return validateProfileForm()">
                                <input type="hidden" name="action" value="update_profile">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Họ và tên</label>
                                        <input type="text" class="form-control" name="fullName" value="${user.fullName}"
                                            pattern="^[^0-9]+$" title="Tên không được chứa số" required>
                                        <div class="invalid-feedback">Tên không được chứa số</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" name="email" value="${user.email}"
                                            pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Vui lòng nhập email hợp lệ" required>
                                        <div class="invalid-feedback">Email không hợp lệ</div>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="form-label">Số điện thoại</label>
                                        <input type="tel" class="form-control" name="phone" value="${user.phone}"
                                            pattern="[0-9]{10}" title="Số điện thoại phải có 10 chữ số">
                                        <div class="invalid-feedback">Số điện thoại phải có 10 chữ số</div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Địa chỉ</label>
                                        <input type="text" class="form-control" name="address" value="${user.address}">
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Cập nhật thông tin</button>
                            </form>
                        </div>

                        <!-- Đổi mật khẩu -->
                        <div class="profile-section">
                            <h4 class="mb-4">Đổi mật khẩu</h4>
                            <form id="passwordForm" action="${pageContext.request.contextPath}/dashboard/profile" method="post" onsubmit="return validatePasswordForm()">
                                <input type="hidden" name="action" value="change_password">
                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Mật khẩu hiện tại</label>
                                        <div class="password-field">
                                            <input type="password" class="form-control" name="currentPassword" id="currentPassword" required>
                                            <i class="toggle-password fas fa-eye-slash" onclick="togglePassword('currentPassword')"></i>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Mật khẩu mới</label>
                                        <div class="password-field">
                                            <input type="password" class="form-control" name="newPassword" id="newPassword" 
                                                pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$" 
                                                title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ và số" required>
                                            <i class="toggle-password fas fa-eye-slash" onclick="togglePassword('newPassword')"></i>
                                            <div class="invalid-feedback">Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ và số</div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Xác nhận mật khẩu mới</label>
                                        <div class="password-field">
                                            <input type="password" class="form-control" name="confirmPassword" id="confirmPassword" required>
                                            <i class="toggle-password fas fa-eye-slash" onclick="togglePassword('confirmPassword')"></i>
                                            <div class="password-match-message" id="passwordMatch"></div>
                                        </div>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-warning">Đổi mật khẩu</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            
            <!-- Validation Script -->
            <script>
                // Validate profile form
                function validateProfileForm() {
                    const form = document.getElementById('profileForm');
                    const inputs = form.querySelectorAll('input');
                    let isValid = true;

                    inputs.forEach(input => {
                        if (input.pattern && !new RegExp(input.pattern).test(input.value)) {
                            input.classList.add('is-invalid');
                            isValid = false;
                        } else {
                            input.classList.remove('is-invalid');
                        }
                    });

                    return isValid;
                }

                // Validate password form
                function validatePasswordForm() {
                    const newPassword = document.getElementById('newPassword');
                    const confirmPassword = document.getElementById('confirmPassword');
                    
                    // Kiểm tra pattern của mật khẩu mới
                    if (!new RegExp(newPassword.pattern).test(newPassword.value)) {
                        newPassword.classList.add('is-invalid');
                        return false;
                    }
                    
                    // Kiểm tra mật khẩu mới và xác nhận mật khẩu có khớp không
                    if (newPassword.value !== confirmPassword.value) {
                        document.getElementById('passwordMatch').style.color = 'red';
                        document.getElementById('passwordMatch').textContent = 'Mật khẩu không khớp!';
                        return false;
                    }
                    
                    return true;
                }

                // Real-time password matching check
                document.getElementById('confirmPassword').addEventListener('input', function() {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = this.value;
                    const matchMessage = document.getElementById('passwordMatch');
                    
                    if (confirmPassword === '') {
                        matchMessage.textContent = '';
                    } else if (newPassword === confirmPassword) {
                        matchMessage.style.color = 'green';
                        matchMessage.textContent = 'Mật khẩu khớp!';
                    } else {
                        matchMessage.style.color = 'red';
                        matchMessage.textContent = 'Mật khẩu không khớp!';
                    }
                });

                // Remove invalid class on input
                document.querySelectorAll('input').forEach(input => {
                    input.addEventListener('input', function() {
                        if (this.classList.contains('is-invalid')) {
                            this.classList.remove('is-invalid');
                        }
                    });
                });

                // Hàm toggle hiển thị/ẩn mật khẩu
                function togglePassword(inputId) {
                    const passwordInput = document.getElementById(inputId);
                    const toggleIcon = passwordInput.nextElementSibling;
                    
                    if (passwordInput.type === 'password') {
                        passwordInput.type = 'text';
                        toggleIcon.classList.remove('fa-eye-slash');
                        toggleIcon.classList.add('fa-eye');
                    } else {
                        passwordInput.type = 'password';
                        toggleIcon.classList.remove('fa-eye');
                        toggleIcon.classList.add('fa-eye-slash');
                    }
                }
            </script>
        </body>

        </html>