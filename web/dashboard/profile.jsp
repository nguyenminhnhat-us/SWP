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
                :root {
                    --primary-green: #28a745;
                    --hover-green: #218838;
                    --yellow: #ffc107;
                    --dark-bg: #28a745;
                    --sidebar-bg: #28a745;
                    --sidebar-hover: #218838;
                    --sidebar-active: #ffc107;
                }

                body {
                    background-color: #f8f9fa;
                    min-height: 100vh;
                    font-family: 'Segoe UI', Arial, sans-serif;
                }

                /* Header Styles */
                .logo-container {
                            display: flex;
                            align-items: center;
                            padding: 10px 0;
                        }

                        .logo-container img {
                            width: 100px;
                            height: auto;
                            margin-right: 15px;
                        }

                        .logo-text {
                            color: #333;
                        }

                        .logo-text h1 {
                            font-size: 24px;
                            margin: 0;
                            color: #28a745;
                        }

                        .search-bar {
                            display: flex;
                            align-items: center;
                            margin: 10px 0;
                        }

                        .search-bar input {
                            flex: 1;
                            padding: 8px 15px;
                            border: 2px solid #28a745;
                            border-radius: 4px 0 0 4px;
                            outline: none;
                        }

                        .search-bar button {
                            padding: 8px 20px;
                            background: #28a745;
                            border: none;
                            color: white;
                            border-radius: 0 4px 4px 0;
                            cursor: pointer;
                        }

                        .header-contact {
                            text-align: right;
                            padding: 10px 0;
                        }

                        .hotline {
                            color: red;
                            font-weight: bold;
                            font-size: 18px;
                        }

                        .header-buttons {
                            text-align: right;
                        }

                        .header-buttons .btn {
                            margin-left: 10px;
                        }

                        /* Navigation */
                        .main-nav {
                            background-color: #28a745;
                            padding: 0;
                        }

                        .main-nav .nav-link {
                            color: white !important;
                            padding: 15px 20px;
                            font-weight: 500;
                            transition: all 0.3s ease;
                        }

                        .main-nav .nav-link:hover {
                            background-color: rgba(255, 255, 255, 0.1);
                            color: yellow !important;
                        }

                        .dropdown-menu {
                            border: none;
                            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                        }

                        .dropdown-item:hover {
                            background-color: #28a745;
                            color: white !important;
                        }

                        .navbar {
                            background-color: #28a745;
                        }

                        .navbar-brand {
                            color: white !important;
                            font-weight: bold;
                        }

                        .nav-link {
                            color: white !important;
                        }

                /* Sidebar Styles */
                .sidebar {
                    background-color: var(--sidebar-bg);
                    width: 250px;
                    padding: 20px 0;
                    min-height: 100%;
                }

                .sidebar .nav-link {
                    color: #fff !important;
                    padding: 12px 20px !important;
                    border-left: 3px solid transparent;
                    transition: all 0.3s ease;
                    font-weight: 500;
                }

                .sidebar .nav-link:hover,
                .sidebar .nav-link.active {
                    background-color: var(--sidebar-hover);
                    color: var(--sidebar-active) !important;
                    border-left-color: var(--sidebar-active);
                }

                .sidebar .nav-link i {
                    width: 20px;
                    text-align: center;
                    margin-right: 10px;
                }

                /* Main Layout */
                .dashboard-container {
                    display: flex;
                    min-height: calc(100vh - 70px);
                }

                /* Content Area */
                .main-content {
                    flex: 1;
                    padding: 30px;
                    background-color: #f8f9fa;
                }

                .profile-section {
                    background: white;
                    border-radius: 15px;
                    padding: 30px;
                    margin-bottom: 30px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
                    border: 1px solid #e9ecef;
                }

                .profile-section h4 {
                    color: var(--primary-green);
                    margin-bottom: 25px;
                    font-weight: 600;
                    border-bottom: 2px solid var(--primary-green);
                    padding-bottom: 10px;
                }

                /* Form Controls */
                .form-label {
                    font-weight: 600;
                    color: #495057;
                    margin-bottom: 8px;
                }

                .form-control {
                    border: 2px solid #e9ecef;
                    padding: 10px 15px;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                }

                .form-control:focus {
                    border-color: var(--primary-green);
                    box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.15);
                }

                /* Buttons */
                .btn-primary, .btn-success {
                    background-color: var(--primary-green);
                    border-color: var(--primary-green);
                    padding: 10px 25px;
                    font-weight: 600;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                }

                .btn-primary:hover, .btn-success:hover {
                    background-color: var(--hover-green);
                    border-color: var(--hover-green);
                }

                .btn-warning {
                    background-color: var(--yellow);
                    border-color: var(--yellow);
                    padding: 10px 25px;
                    font-weight: 600;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                    color: #000;
                }

                .btn-warning:hover {
                    background-color: #e0a800;
                    border-color: #e0a800;
                }

                /* Alerts */
                .alert {
                    border-radius: 8px;
                    padding: 15px 20px;
                    margin-bottom: 25px;
                    border: none;
                }

                .alert-success {
                    background-color: #d4edda;
                    color: #155724;
                    border-left: 4px solid var(--primary-green);
                }

                .alert-danger {
                    background-color: #f8d7da;
                    color: #721c24;
                    border-left: 4px solid #dc3545;
                }

                /* Password Fields */
                .password-field {
                    position: relative;
                }

                .toggle-password {
                    position: absolute;
                    right: 15px;
                    top: 50%;
                    transform: translateY(-50%);
                    cursor: pointer;
                    color: #6c757d;
                    transition: color 0.3s ease;
                }

                .toggle-password:hover {
                    color: var(--primary-green);
                }

                .password-match-message {
                    margin-top: 5px;
                    font-size: 0.875em;
                }

                /* Responsive */
                @media (max-width: 768px) {
                    .dashboard-container {
                        flex-direction: column;
                    }
                    .sidebar {
                        width: 100%;
                        min-height: auto;
                    }
                    .profile-section {
                        padding: 20px;
                    }
                    .search-box {
                        max-width: 100%;
                        margin: 10px 0;
                    }
                }
            </style>
        </head>

        <body>
            <jsp:include page="../common/home/header.jsp" />
            
            <div class="dashboard-container">
                <!-- Sidebar -->
                <div class="sidebar">
                    <jsp:include page="../common/dashboard/sidebar.jsp" />
                </div>

                <!-- Main Content -->
                <div class="main-content">
                    <h2 class="mb-4">Thông tin cá nhân</h2>

                    <!-- Alerts -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <!-- Profile Information -->
                    <div class="profile-section">
                        <h4>Thông tin cơ bản</h4>
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
                                        pattern="[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$" title="Vui lòng nhập email hợp lệ" required>
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

                    <!-- Change Password -->
                    <div class="profile-section">
                        <h4>Đổi mật khẩu</h4>
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